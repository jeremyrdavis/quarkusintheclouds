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

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = var.location
  name                = "cluster-${var.random_num}"
  resource_group_name = var.resource_group_name
  dns_prefix          = "dns-${var.random_num}"

  identity {
    type         = "UserAssigned"
    identity_ids = [var.keyvault_identity_id]
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.node_count
  }

  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}