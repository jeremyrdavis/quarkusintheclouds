# KeyVault variables
variable "keyvault_name" {
  description = "Name of the Key Vault"
  type        = string
  default     = "qiakv"
}

variable "keyvault_secret_name" {
  description = "Name of the Key Vault secret"
  type        = string
  default     = "qiakvsecret"
}

variable "keyvault_secret_value" {
  description = "Value of the Key Vault secret"
  type        = string
  default     = "mynewsecret"
}

variable "resource_group_name" {
    description = "Name of the Resource Group"
    type        = string
    default     = "qz-rg"

}

variable "location" {
    description = "Location of the Resource Group"
    type        = string
    default     = "eastus"
}

variable "tenant_id" {
    description = "Tenant ID"
    type        = string
    default     = "NONE"
}

variable "object_id" {
    description = "Object ID"
    type        = string
    default     = "NONE"
}

