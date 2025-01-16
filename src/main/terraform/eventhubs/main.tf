# Global
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Event Hubs
resource "azurerm_eventhub_namespace" "main" {
  name                = var.eventhubs_namespace_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard"
}

resource "azurerm_eventhub" "example" {
  name               = var.eventhubs_namespace_name
  namespace_id        = azurerm_eventhub_namespace.main.id
  partition_count     = 2
  message_retention = 1
}


