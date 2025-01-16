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

