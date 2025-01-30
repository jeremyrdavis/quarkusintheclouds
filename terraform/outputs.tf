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