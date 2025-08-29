# # ARO outputs
# output "aro-cluster_name" {
#   description = "Name of the ARO cluster"
#   value       = module.aro.cluster_name
# }

# output "aro-console_url" {
#   description = "URL of the OpenShift console"
#   value       = module.aro.console_url
# }

# output "aro-cluster_info" {
#   description = "Basic ARO cluster information"
#   value       = module.aro.cluster_info
# }

# output "aro-virtual_network_id" {
#   description = "ID of the ARO virtual network"
#   value       = module.aro.virtual_network_id
# }

# output "aro-service_principal_client_id" {
#   description = "Client ID of the service principal created for ARO"
#   value       = module.aro.service_principal_client_id
# }

# output "aro-service_principal_object_id" {
#   description = "Object ID of the service principal created for ARO"
#   value       = module.aro.service_principal_object_id
# }

# Managed Identity outputs
output "managed_identity_id" {
  description = "ID of the user-assigned managed identity for Key Vault access"
  value       = module.managed_identity.identity_id
}

output "managed_identity_client_id" {
  description = "Client ID of the user-assigned managed identity"
  value       = module.managed_identity.identity_client_id
}

output "managed_identity_principal_id" {
  description = "Principal ID of the user-assigned managed identity"
  value       = module.managed_identity.identity_principal_id
}

# Functions outputs
output "function_app_name" {
  description = "Name of the Azure Function App"
  value       = module.functions.function_app_name
}

output "function_app_hostname" {
  description = "Default hostname of the Function App"
  value       = module.functions.function_app_default_hostname
}