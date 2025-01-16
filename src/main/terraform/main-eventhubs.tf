# Event Hubs
resource "azurerm_eventhub_namespace" "main" {
  name                = "${var.eventhubs_namespace_name}-${random_integer.num.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard"
}

resource "azurerm_eventhub" "example" {
  name               = "${var.eventhubs_namespace_name}-${random_integer.num.result}"
  namespace_id        = azurerm_eventhub_namespace.main.id
  partition_count     = 2
  message_retention = 1
}


