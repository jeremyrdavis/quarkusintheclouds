# Event Hubs
resource "azurerm_eventhub_namespace" "main" {
  name                = var.eventhubs_namespace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
}

resource "azurerm_eventhub" "example" {
  name               = var.eventhubs_namespace_name
  namespace_id        = azurerm_eventhub_namespace.main.id
  partition_count     = 2
  message_retention = 1
}


