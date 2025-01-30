# Event Hubs variables
variable "eventhubs_namespace_name" {
  description = "Name of the Event Hubs namespace"
  type        = string
  default     = "qazeventhubnamespace"
}

variable "eventhubs_name" {
  description = "Name of the Event Hub"
  type        = string
  default     = "qazeventhub"
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

