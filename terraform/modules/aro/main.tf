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

# Azure Red Hat OpenShift Cluster
resource "azurerm_redhat_openshift_cluster" "aro" {
  name                = "aro-cluster-${var.random_num}"
  resource_group_name = var.resource_group_name
  location            = var.location

  cluster_profile {
    domain          = var.domain
    resource_group_id = var.resource_group_id
    fips_enabled    = false
    version         = "4.14.0"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
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
    azurerm_subnet.worker_subnet
  ]
} 