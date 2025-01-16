# Global variables
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
  default     = "rg-qaz2"
}

variable "location" {
  description = "Azure location for resources"
  type        = string
  default     = "eastus"
}

# CosmosDB variables
variable "cosmos_account_name" {
  description = "Name of the Cosmos DB account"
  type        = string
  default     = "qazaccount2"
}

variable "cosmos_db_name" {
  description = "Name of the Cosmos DB database"
  type        = string
  default     = "qazdb2"
}

variable "cosmos_container_name" {
  description = "Name of the Cosmos DB container"
  type        = string
  default     = "qazcontainer2"
}


