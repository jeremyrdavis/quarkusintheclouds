terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.15.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

# Get ARO resource provider service principal
data "azuread_service_principal" "aro_resource_provider" {
  client_id = "f1dd0a37-89c6-4e07-bcd1-ffd3d43d8875"  # ARO resource provider application ID
}

# Create service principal for ARO
resource "azuread_application" "aro_app" {
  display_name = "aro-service-principal-${var.random_num}"
}

resource "azuread_service_principal" "aro_sp" {
  client_id = azuread_application.aro_app.client_id
}

resource "azuread_service_principal_password" "aro_sp_password" {
  service_principal_id = azuread_service_principal.aro_sp.id
}

# Assign contributor role to the service principal
resource "azurerm_role_assignment" "aro_contributor" {
  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aro_sp.object_id

  depends_on = [azuread_service_principal.aro_sp]
}

# Virtual Network for ARO
resource "azurerm_virtual_network" "aro_vnet" {
  name                = "aro-vnet-${var.random_num}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/23"]

  tags = var.tags
}

# Master subnet
resource "azurerm_subnet" "master_subnet" {
  name                 = "master-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aro_vnet.name
  address_prefixes     = ["10.0.0.0/27"]

  service_endpoints = ["Microsoft.ContainerRegistry"]

  depends_on = [azurerm_virtual_network.aro_vnet]
}

# Worker subnet
resource "azurerm_subnet" "worker_subnet" {
  name                 = "worker-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aro_vnet.name
  address_prefixes     = ["10.0.0.128/25"]

  service_endpoints = ["Microsoft.ContainerRegistry"]

  depends_on = [azurerm_virtual_network.aro_vnet]
}

# Assign Network Contributor role to ARO resource provider service principal
resource "azurerm_role_assignment" "aro_network_contributor" {
  scope                = azurerm_virtual_network.aro_vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.aro_resource_provider.object_id

  depends_on = [azurerm_virtual_network.aro_vnet]
}

# Azure Red Hat OpenShift Cluster
resource "azurerm_redhat_openshift_cluster" "aro" {
  name                = "aro-cluster-${var.random_num}"
  resource_group_name = var.resource_group_name
  location            = var.location

  cluster_profile {
    domain       = var.domain
    fips_enabled = false
    version      = "4.17.27"
  }

  service_principal {
    client_id     = azuread_application.aro_app.client_id
    client_secret = azuread_service_principal_password.aro_sp_password.value
  }

  network_profile {
    pod_cidr     = "10.128.0.0/14"
    service_cidr = "172.30.0.0/16"
  }

  main_profile {
    subnet_id = azurerm_subnet.master_subnet.id
    vm_size   = var.master_vm_size
  }

  worker_profile {
    vm_size    = var.worker_vm_size
    disk_size_gb = var.worker_disk_size_gb
    subnet_id  = azurerm_subnet.worker_subnet.id
    node_count = var.worker_node_count
  }

  api_server_profile {
    visibility = "Public"
  }

  ingress_profile {
    visibility = "Public"
  }

  tags = var.tags

  depends_on = [
    azurerm_subnet.master_subnet,
    azurerm_subnet.worker_subnet,
    azurerm_role_assignment.aro_contributor,
    azurerm_role_assignment.aro_network_contributor
  ]
} 