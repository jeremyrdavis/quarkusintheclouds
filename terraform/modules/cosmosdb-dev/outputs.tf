output "cosmosdb_endpoint_dev" {
  description = "The endpoint of the CosmosDB account"
  value       = azurerm_cosmosdb_account.main.endpoint
  sensitive = true
}

output "cosmosdb_primary_key_dev" {
  description = "The primary key of the CosmosDB account"
  value       = azurerm_cosmosdb_account.main.primary_key
  sensitive = true
}