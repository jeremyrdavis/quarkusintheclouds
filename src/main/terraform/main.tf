provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.azure_resource_group
  location = var.location
}

resource "azurerm_app_configuration" "main" {
  name                = var.azure_app_config
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard"
}

resource "azurerm_app_configuration_key" "key1" {
  name                = "myKeyOne"
  value               = "Value 1"
  app_configuration_id = azurerm_app_configuration.main.id
}

resource "azurerm_app_configuration_key" "key2" {
  name                = "myKeyTwo"
  value               = "Value 2"
  app_configuration_id = azurerm_app_configuration.main.id
}

resource "azurerm_cosmosdb_account" "main" {
  name                = var.cosmos_account
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    location          = var.region_name
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "main" {
  name                = var.cosmos_db_name
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
}

resource "azurerm_cosmosdb_sql_container" "main" {
  name                = var.cosmos_container_name
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
  database_name       = azurerm_cosmosdb_sql_database.main.name
  partition_key_path  = "/id"
}

output "cosmos_endpoint" {
  value = azurerm_cosmosdb_account.main.endpoint
}

output "cosmos_key" {
  value = azurerm_cosmosdb_account.main.primary_master_key
}