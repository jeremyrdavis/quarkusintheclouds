# Duplicate
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


# App Config
variable "app_config_name" {
  description = "Name of the App Configuration"
  type        = string
  default     = "qaz-appconfig"
}

