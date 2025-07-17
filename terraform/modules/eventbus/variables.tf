# Azure Service Bus (Event Bus) variables
variable "eventbus_namespace_name" {
  description = "Name of the Service Bus namespace"
  type        = string
  default     = "qaz-eventbus-namespace"
}

variable "eventbus_queue_name" {
  description = "Name of the Service Bus queue"
  type        = string
  default     = "qaz-eventbus-queue"
}

variable "eventbus_topic_name" {
  description = "Name of the Service Bus topic"
  type        = string
  default     = "qaz-eventbus-topic"
}

variable "eventbus_subscription_name" {
  description = "Name of the Service Bus subscription"
  type        = string
  default     = "qaz-eventbus-subscription"
}

variable "eventbus_sku" {
  description = "SKU of the Service Bus namespace"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.eventbus_sku)
    error_message = "SKU must be Basic, Standard, or Premium."
  }
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

variable "create_topic" {
  description = "Whether to create a Service Bus topic"
  type        = bool
  default     = true
}

variable "max_size_in_megabytes" {
  description = "Maximum size of the queue in megabytes"
  type        = number
  default     = 1024
}

variable "max_delivery_count" {
  description = "Maximum number of delivery attempts"
  type        = number
  default     = 10
}
