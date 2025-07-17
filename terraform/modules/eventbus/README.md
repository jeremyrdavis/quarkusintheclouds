# Azure Service Bus (Event Bus) Module

This Terraform module creates an Azure Service Bus namespace and related resources for event-driven messaging.

## Resources Created

- **Azure Service Bus Namespace**: Main namespace for messaging
- **Azure Service Bus Queue**: Queue for point-to-point messaging
- **Azure Service Bus Topic** (optional): Topic for publish-subscribe messaging
- **Azure Service Bus Subscription** (optional): Subscription for the topic

## Usage

```hcl
module "eventbus" {
  source = "./modules/eventbus"
  
  eventbus_namespace_name = "my-eventbus-namespace"
  eventbus_queue_name     = "my-queue"
  eventbus_topic_name     = "my-topic"
  resource_group_name     = "my-resource-group"
  location                = "eastus"
  eventbus_sku            = "Standard"
  create_topic            = true
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| eventbus_namespace_name | Name of the Service Bus namespace | string | "qaz-eventbus-namespace" | no |
| eventbus_queue_name | Name of the Service Bus queue | string | "qaz-eventbus-queue" | no |
| eventbus_topic_name | Name of the Service Bus topic | string | "qaz-eventbus-topic" | no |
| eventbus_subscription_name | Name of the Service Bus subscription | string | "qaz-eventbus-subscription" | no |
| eventbus_sku | SKU of the Service Bus namespace | string | "Standard" | no |
| resource_group_name | Name of the Resource Group | string | "qz-rg" | no |
| location | Location of the Resource Group | string | "eastus" | no |
| create_topic | Whether to create a Service Bus topic | bool | true | no |
| max_size_in_megabytes | Maximum size of the queue in megabytes | number | 1024 | no |
| max_delivery_count | Maximum number of delivery attempts | number | 10 | no |

## Outputs

| Name | Description |
|------|-------------|
| eventbus_namespace_id | ID of the Service Bus namespace |
| eventbus_namespace_name | Name of the Service Bus namespace |
| eventbus_queue_id | ID of the Service Bus queue |
| eventbus_queue_name | Name of the Service Bus queue |
| eventbus_topic_id | ID of the Service Bus topic |
| eventbus_topic_name | Name of the Service Bus topic |
| eventbus_subscription_id | ID of the Service Bus subscription |
| eventbus_subscription_name | Name of the Service Bus subscription |
| eventbus_connection_string | Connection string for the Service Bus namespace (sensitive) |

## SKU Options

- **Basic**: Basic messaging capabilities
- **Standard**: Standard messaging with topics and subscriptions
- **Premium**: Premium messaging with enhanced performance and features

## Notes

- The module creates a queue by default for point-to-point messaging
- Topic and subscription creation is controlled by the `create_topic` variable
- Connection strings are marked as sensitive and will not be displayed in logs
- The module follows Azure naming conventions and best practices
