# Azure Service Bus (Event Bus) Module
# This module creates an Azure Service Bus namespace and queue

resource "azurerm_servicebus_namespace" "main" {
  name                = var.eventbus_namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.eventbus_sku
}

resource "azurerm_servicebus_queue" "main" {
  name         = var.eventbus_queue_name
  namespace_id = azurerm_servicebus_namespace.main.id

  max_size_in_megabytes = var.max_size_in_megabytes
}

# Optional: Create a topic for pub/sub scenarios
resource "azurerm_servicebus_topic" "main" {
  count        = var.create_topic ? 1 : 0
  name         = var.eventbus_topic_name
  namespace_id = azurerm_servicebus_namespace.main.id
}

# Optional: Create a subscription for the topic
resource "azurerm_servicebus_subscription" "main" {
  count               = var.create_topic ? 1 : 0
  name                = var.eventbus_subscription_name
  topic_id            = azurerm_servicebus_topic.main[0].id
  max_delivery_count  = var.max_delivery_count
}
