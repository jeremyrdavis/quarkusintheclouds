output "identity_id" {
  description = "ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.keyvault_identity.id
}

output "identity_client_id" {
  description = "Client ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.keyvault_identity.client_id
}

output "identity_principal_id" {
  description = "Principal ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.keyvault_identity.principal_id
}

output "identity_name" {
  description = "Name of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.keyvault_identity.name
}