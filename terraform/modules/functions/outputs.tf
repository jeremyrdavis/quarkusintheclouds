output "function_app_name" {
  description = "Name of the Function App"
  value       = azurerm_linux_function_app.quarkus_functions.name
}

output "function_app_id" {
  description = "ID of the Function App"
  value       = azurerm_linux_function_app.quarkus_functions.id
}

output "function_app_default_hostname" {
  description = "Default hostname of the Function App"
  value       = azurerm_linux_function_app.quarkus_functions.default_hostname
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.functions_storage.name
}