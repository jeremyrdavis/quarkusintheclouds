terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.15.0"
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
    subscription_id = var.subscription_id
}

resource "azurerm_key_vault" "example" {
  name                        = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Create"
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set"
    ]

    storage_permissions = [
      "Get",
      "List",
      "Set"
    ]
  }
}

resource "azurerm_key_vault_secret" "secret1" {
  name         = var.keyvault_secret_name
  value        = var.keyvault_secret_value
  key_vault_id = azurerm_key_vault.example.id
}
