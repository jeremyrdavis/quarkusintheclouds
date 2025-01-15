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
  default     = "mynewsecret"
}

