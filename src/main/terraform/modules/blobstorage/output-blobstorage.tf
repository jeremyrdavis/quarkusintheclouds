output "storage_blob_endpoint" {
  value = azurerm_storage_account.main.primary_blob_endpoint
}

output "storage_blob_connection_string" {
  value = azurerm_storage_account.main.primary_connection_string
  sensitive = true
}