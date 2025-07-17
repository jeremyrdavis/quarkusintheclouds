# Azure Service Bus (Event Bus) outputs
output "eventbus_namespace_id" {
  description = "ID of the Service Bus namespace"
  value       = azurerm_servicebus_namespace.main.id
}

output "eventbus_namespace_name" {
  description = "Name of the Service Bus namespace"
  value       = azurerm_servicebus_namespace.main.name
}

output "eventbus_queue_id" {
  description = "ID of the Service Bus queue"
  value       = azurerm_servicebus_queue.main.id
}

output "eventbus_queue_name" {
  description = "Name of the Service Bus queue"
  value       = azurerm_servicebus_queue.main.name
}

output "eventbus_topic_id" {
  description = "ID of the Service Bus topic"
  value       = var.create_topic ? azurerm_servicebus_topic.main[0].id : null
}

output "eventbus_topic_name" {
  description = "Name of the Service Bus topic"
  value       = var.create_topic ? azurerm_servicebus_topic.main[0].name : null
}

output "eventbus_subscription_id" {
  description = "ID of the Service Bus subscription"
  value       = var.create_topic ? azurerm_servicebus_subscription.main[0].id : null
}

output "eventbus_subscription_name" {
  description = "Name of the Service Bus subscription"
  value       = var.create_topic ? azurerm_servicebus_subscription.main[0].name : null
}

output "eventbus_connection_string" {
  description = "Connection string for the Service Bus namespace"
  value       = azurerm_servicebus_namespace.main.default_primary_connection_string
  sensitive   = true
}
