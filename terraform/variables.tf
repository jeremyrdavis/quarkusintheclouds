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

# ARO Variables
variable "aro_domain" {
  description = "Domain for the ARO cluster"
  type        = string
  default     = "quarkusintheclouds"
}

variable "aro_pull_secret" {
  description = "Red Hat pull secret for ARO cluster"
  type        = string
  sensitive   = true
}

variable "aro_worker_node_count" {
  description = "Number of worker nodes for ARO cluster"
  type        = number
  default     = 3
}

variable "aro_master_vm_size" {
  description = "VM size for ARO master nodes"
  type        = string
  default     = "Standard_D8s_v3"
}

variable "aro_worker_vm_size" {
  description = "VM size for ARO worker nodes"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

