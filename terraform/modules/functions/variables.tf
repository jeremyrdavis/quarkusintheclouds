variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
}

variable "random_num" {
  description = "Random number for unique resource naming"
  type        = string
}

variable "keyvault_identity_id" {
  type        = string
  description = "ID of the user-assigned managed identity for Key Vault access"
}