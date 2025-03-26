variable "subscription_id" {
  description = "Azure Subscription ID"
    type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "East US"
}

variable "cosmos_account_name" {
  description = "The name of the CosmosDB account"
  type        = string
}

variable "cosmos_db_name" {
  description = "The name of the CosmosDB database"
  type        = string
}

variable "cosmos_container_name" {
  description = "The name of the CosmosDB container"
  type        = string
}