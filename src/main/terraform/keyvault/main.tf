variable "subscription_id" {
    description = "Azure subscription ID"
    type        = string
    default     = "SUBSCRIPTION_ID"
}
variable "tenant_id" {
    description = "Azure tenant ID"
    type        = string
    default     = "TENANT_ID"
}
variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
  default     = "rg-qaz"
}

variable "location" {
  description = "Azure location for resources"
  type        = string
  default     = "eastus"
}

variable "keyvault_name" {
  description = "Name of the Key Vault"
  type        = string
  default     = "qazkeyvault"
}

variable "keyvault_secret_name" {
  description = "Name of the Key Vault secret"
  type        = string
  default     = "qaz-secret"
}

variable "keyvault_secret_value" {
  description = "Value of the Key Vault secret"
  type        = string
  default     = "myothersecret"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.15.0"
    }
  }
}

data "azurerm_client_config" "current" {}

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
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}
