output "cluster_name" {
  description = "Name of the ARO cluster"
  value       = azurerm_redhat_openshift_cluster.aro.name
}

output "cluster_id" {
  description = "ID of the ARO cluster"
  value       = azurerm_redhat_openshift_cluster.aro.id
}

output "console_url" {
  description = "URL of the OpenShift console"
  value       = azurerm_redhat_openshift_cluster.aro.console_url
}

output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.aro_vnet.id
}

output "master_subnet_id" {
  description = "ID of the master subnet"
  value       = azurerm_subnet.master_subnet.id
}

output "worker_subnet_id" {
  description = "ID of the worker subnet"
  value       = azurerm_subnet.worker_subnet.id
}

output "cluster_info" {
  description = "Basic cluster information"
  value = {
    name = azurerm_redhat_openshift_cluster.aro.name
    id   = azurerm_redhat_openshift_cluster.aro.id
    console_url = azurerm_redhat_openshift_cluster.aro.console_url
  }
} 