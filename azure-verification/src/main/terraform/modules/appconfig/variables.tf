# App Config
variable "role_id" {
  description = "Id of the App Configuration data owner"
  type = string
  default = "NONE"
}

variable "app_config_name" {
  description = "Name of the App Configuration"
  type        = string
  default     = "qaz-appconfig"
}

variable "resource_group_id" {
    description = "Id of the Resource Group"
    type = string
    default = "NONE"
}

variable "resource_group_name" {
    description = "Name of the Resource Group"
    type = string
    default = "NONE"
}

variable "location" {
    description = "Location of the Resource Group"
    type = string
    default = "eastus"
}
