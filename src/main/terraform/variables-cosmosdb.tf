# CosmosDB variables
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


