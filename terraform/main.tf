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
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}


provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  username               = module.aks.cluster_username
  password               = module.aks.cluster_password
}

module "k8s_app" {
  source        = "./modules/k8s_app"
  namespace     = "myapp"
  back_image    = "nginx:1.25-alpine"   # Replace with your backend image
  front_image   = "nginx:1.25-alpine"   # Replace with your frontend image
  back_replicas = 2
  front_replicas = 2
  config_data   = {
    SOME_KEY = "some_value"
  }
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

# Managed Identity for Key Vault access
module "managed_identity" {
  source              = "./modules/managed_identity"
  identity_name       = "qaz-keyvault-identity-${random_integer.num.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  key_vault_id        = module.keyvault.keyvault_id
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

module "aks" {
  source = "./modules/aks"
  subscription_id = data.azurerm_client_config.current.subscription_id
  location = var.location
  random_num = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  resource_group_id = azurerm_resource_group.main.id
  keyvault_identity_id = module.managed_identity.identity_id
}

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

module "cosmosdb" {
  source = "./modules/cosmosdb"
  cosmos_account_name = "qaz-cosmos${random_integer.num.result}"
  cosmos_db_name = "qaz-cosmosdb${random_integer.num.result}"
  cosmos_container_name = "qaz-cosmoscontainer${random_integer.num.result}"
  resource_group_name = azurerm_resource_group.main.name
}

module "eventhubs" {
  source = "./modules/eventhubs"
  eventhubs_namespace_name = "qaz-eventhubs-${random_integer.num.result}"
   resource_group_name = azurerm_resource_group.main.name
}

module "keyvault" {
  source = "./modules/keyvault"
    keyvault_name = "qaz-kv-${random_integer.num.result}"
    keyvault_secret_name = "qaz-kv-secret-${random_integer.num.result}"
    keyvault_secret_value = "mynewsecret-${random_integer.num.result}"
    resource_group_name = azurerm_resource_group.main.name
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
}

module "containerapps" {
  source = "./modules/containerapps"
  environment_name = "qaz-containerapps-${random_integer.num.result}"
  location = var.location
  resource_group_name = azurerm_resource_group.main.name
  keyvault_identity_id = module.managed_identity.identity_id
}

module "eventbus" {
  source = "./modules/eventbus"
  eventbus_namespace_name = "qaz-eventbus-${random_integer.num.result}"
  eventbus_queue_name = "qaz-eventbus-queue-${random_integer.num.result}"
  eventbus_topic_name = "qaz-eventbus-topic-${random_integer.num.result}"
  eventbus_subscription_name = "qaz-eventbus-sub-${random_integer.num.result}"
  resource_group_name = azurerm_resource_group.main.name
  location = var.location
  eventbus_sku = "Standard"
  create_topic = true
}

# module "aro" {
#   source = "./modules/aro"
#   location = var.location
#   resource_group_name = azurerm_resource_group.main.name
#   resource_group_id = azurerm_resource_group.main.id
#   random_num = random_integer.num.result
#   domain = var.aro_domain
#   pull_secret = var.aro_pull_secret
#   worker_node_count = var.aro_worker_node_count
#   master_vm_size = var.aro_master_vm_size
#   worker_vm_size = var.aro_worker_vm_size
#   tags = var.tags
#   keyvault_identity_id = module.managed_identity.identity_id
# }

module "functions" {
  source = "./modules/functions"
  resource_group_name = azurerm_resource_group.main.name
  location = var.location
  random_num = random_integer.num.result
  keyvault_identity_id = module.managed_identity.identity_id
}

