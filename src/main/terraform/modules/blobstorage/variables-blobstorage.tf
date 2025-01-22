# Blob Storage variables
variable "storage_account_name" {
  description = "Name of the Storage Account"
  type        = string
  default     = "qazblob"
}

variable "resource_group_name" {
    description = "Name of the Resource Group"
    type        = string
    default = "qz-rg"
}

variable "location" {
    description = "Location of the Resource Group"
    type        = string
    default     = "eastus"
}