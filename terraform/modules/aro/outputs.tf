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

output "service_principal_client_id" {
  description = "Client ID of the service principal created for ARO"
  value       = azuread_application.aro_app.client_id
}

output "service_principal_object_id" {
  description = "Object ID of the service principal created for ARO"
  value       = azuread_service_principal.aro_sp.object_id
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