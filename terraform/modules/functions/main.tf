# Storage Account for Azure Functions
resource "azurerm_storage_account" "functions_storage" {
  name                     = "qazfunc${var.random_num}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Service Plan for Azure Functions
resource "azurerm_service_plan" "functions_plan" {
  name                = "qaz-functions-plan-${var.random_num}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

# Linux Function App
resource "azurerm_linux_function_app" "quarkus_functions" {
  name                = "qaz-quarkus-functions-${var.random_num}"
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name       = azurerm_storage_account.functions_storage.name
  storage_account_access_key = azurerm_storage_account.functions_storage.primary_access_key
  service_plan_id            = azurerm_service_plan.functions_plan.id

  identity {
    type         = "UserAssigned"
    identity_ids = [var.keyvault_identity_id]
  }

  site_config {
    application_stack {
      java_version = "17"
    }
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "java"
    "AzureWebJobsFeatureFlags" = "EnableWorkerIndexing"
  }
}