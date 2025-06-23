variable "location" {
  type        = string
  default     = "eastus"
  description = "Location of the ARO cluster."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the ARO cluster will be created."
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID for the ARO cluster."
}

variable "random_num" {
  type        = string
  description = "Random number to generate unique resource names."
}

variable "domain" {
  type        = string
  description = "Domain for the ARO cluster."
  default     = "quarkusintheclouds"
}

variable "client_id" {
  type        = string
  description = "Service principal client ID for ARO cluster."
}

variable "client_secret" {
  type        = string
  description = "Service principal client secret for ARO cluster."
  sensitive   = true
}

variable "master_vm_size" {
  type        = string
  description = "VM size for master nodes."
  default     = "Standard_D8s_v3"
}

variable "worker_vm_size" {
  type        = string
  description = "VM size for worker nodes."
  default     = "Standard_D4s_v3"
}

variable "worker_node_count" {
  type        = number
  description = "Number of worker nodes."
  default     = 3
}

variable "worker_disk_size_gb" {
  type        = number
  description = "Disk size in GB for worker nodes."
  default     = 128
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the ARO cluster."
  default     = {}
} 