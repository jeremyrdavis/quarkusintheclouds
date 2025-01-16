# Global
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

variable "location" {
  description = "Azure location for resources"
  type        = string
  default     = "eastus"
}

