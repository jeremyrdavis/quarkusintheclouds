# Reference the outputs from the aks module
output "kubernetes_cluster_name" {
  value = module.aks.kubernetes_cluster_name
}

output "aks-client_certificate" {
  value     = module.aks.client_certificate
  sensitive = true
}

output "aks-client_key" {
  value     = module.aks.client_key
  sensitive = true
}

output "aks-cluster_ca_certificate" {
  value     = module.aks.cluster_ca_certificate
  sensitive = true
}

output "aks-cluster_password" {
  value     = module.aks.cluster_password
  sensitive = true
}

output "aks-cluster_username" {
  value     = module.aks.cluster_username
  sensitive = true
}

output "aks-host" {
  value     = module.aks.host
  sensitive = true
}

output "aks-kube_config" {
  value     = module.aks.kube_config
  sensitive = true
}

output "aca-frontend-url" {
  value = module.containerapps.frontend_url
}

output "aca-backend-url" {
  value = module.containerapps.backend_url
}

# ARO outputs
output "aro-cluster_name" {
  description = "Name of the ARO cluster"
  value       = module.aro.cluster_name
}

output "aro-console_url" {
  description = "URL of the OpenShift console"
  value       = module.aro.console_url
}

output "aro-api_server_url" {
  description = "URL of the OpenShift API server"
  value       = module.aro.api_server_url
}

output "aro-cluster_credentials" {
  description = "Cluster credentials for OpenShift (username, password, host)"
  value       = module.aro.cluster_credentials
  sensitive   = true
}

output "aro-kubeconfig" {
  description = "Kubeconfig for the ARO cluster"
  value       = module.aro.kubeconfig
  sensitive   = true
}