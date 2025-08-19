# Variables for the k8s_app module
variable "namespace" {
  description = "Namespace to deploy resources into"
  type        = string
  default     = "default"
}

variable "back_image" {
  description = "Container image for the backend deployment"
  type        = string
}

variable "front_image" {
  description = "Container image for the frontend deployment"
  type        = string
}

variable "back_replicas" {
  description = "Number of backend replicas"
  type        = number
  default     = 1
}

variable "front_replicas" {
  description = "Number of frontend replicas"
  type        = number
  default     = 1
}

variable "config_data" {
  description = "Map of config values for the configmap"
  type        = map(string)
  default     = {}
}
