# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.15.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false
    }
  }
  subscription_id = var.subscription_id
}

resource "random_integer" "num" {
  min = 1
  max = 9999
  keepers = {
    first = "${timestamp()}"
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${random_integer.num.result}"
  location = var.location
}

data "azurerm_client_config" "current" {}

module "appconfig" {
  source            = "./modules/appconfig"
  role_id           = data.azurerm_client_config.current.object_id
  app_config_name   = "qaz-appconfig-${random_integer.num.result}"
  resource_group_id = azurerm_resource_group.main.id
  resource_group_name = azurerm_resource_group.main.name
}

module "blobstorage"{
    source = "./modules/blobstorage"
    resource_group_name = azurerm_resource_group.main.name
    storage_account_name = "qazstorage${random_integer.num.result}"
    location = var.location
}
