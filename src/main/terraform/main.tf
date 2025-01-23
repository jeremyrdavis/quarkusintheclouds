# Azure Provider source and version being used
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

module "aks" {
  source = "./modules/aks"
  subscription_id = data.azurerm_client_config.current.subscription_id
  resource_group_location = var.location

}

#module "appconfig" {
#  source            = "./modules/appconfig"
#  role_id           = data.azurerm_client_config.current.object_id
#  app_config_name   = "qaz-appconfig-${random_integer.num.result}"
#  resource_group_id = azurerm_resource_group.main.id
#  resource_group_name = azurerm_resource_group.main.name
#}

# module "blobstorage"{
#     source = "./modules/blobstorage"
#     resource_group_name = azurerm_resource_group.main.name
#     storage_account_name = "qazstorage${random_integer.num.result}"
#     location = var.location
# }

# module "cosmosdb" {
#   source = "./modules/cosmosdb"
#   cosmos_account_name = "qaz-cosmos${random_integer.num.result}"
#   cosmos_db_name = "qaz-cosmosdb${random_integer.num.result}"
#   cosmos_container_name = "qaz-cosmoscontainer${random_integer.num.result}"
#   resource_group_name = azurerm_resource_group.main.name
# }
#
# module "eventhubs" {
#   source = "./modules/eventhubs"
#   eventhubs_namespace_name = "qaz-eventhubs-${random_integer.num.result}"
#    resource_group_name = azurerm_resource_group.main.name
# }
#
# module "keyvault" {
#   source = "./modules/keyvault"
#     keyvault_name = "qaz-kv-${random_integer.num.result}"
#     keyvault_secret_name = "qaz-kv-secret-${random_integer.num.result}"
#     keyvault_secret_value = "mynewsecret-${random_integer.num.result}"
#     resource_group_name = azurerm_resource_group.main.name
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id
# }

