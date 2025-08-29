variable "identity_name" {
  description = "Name of the user-assigned managed identity"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region location"
  type        = string
}

variable "key_vault_id" {
  description = "ID of the Key Vault to grant access to"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}