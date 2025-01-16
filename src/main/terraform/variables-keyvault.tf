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

