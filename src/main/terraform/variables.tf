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

variable "app_config_name" {
  description = "Name of the App Configuration"
  type        = string
  default     = "qaz-appconfig"
}

variable "cosmos_account_name" {
  description = "Name of the Cosmos DB account"
  type        = string
  default     = "qazaccount"
}

variable "cosmos_db_name" {
  description = "Name of the Cosmos DB database"
  type        = string
  default     = "qazdb"
}

variable "cosmos_container_name" {
  description = "Name of the Cosmos DB container"
  type        = string
  default     = "qazcontainer"
}

variable "eventhubs_namespace_name" {
  description = "Name of the Event Hubs namespace"
  type        = string
  default     = "qazeventhubnamespace"
}

variable "eventhubs_name" {
  description = "Name of the Event Hub"
  type        = string
  default     = "qazeventhub"
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

variable "storage_account_name" {
  description = "Name of the Storage Account"
  type        = string
  default     = "qazblob"
}