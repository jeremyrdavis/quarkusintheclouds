variable "subscription_id" {
  type        = string
  default     = "NONE"
  description = "Subscription id"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_id" {
    type        = string
    default     = "NONE"
    description = "Resource group id"
}

variable "random_num" {
  type = string
  default = "1000"
  description = "Random number to generate unique resource group name."
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 3
}

variable "msi_id" {
  type        = string
  description = "The Managed Service Identity ID. Set this value if you're running this example using Managed Identity as the authentication method."
  default     = null
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}