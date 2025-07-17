# Azure Service Bus (Event Bus) Module

This Terraform module creates an Azure Service Bus namespace and related resources for event-driven messaging and microservices communication. Azure Service Bus is a fully managed message broker service that provides reliable message queuing and durable publish-subscribe messaging patterns.

## Overview

Azure Service Bus is ideal for:

- **Decoupling applications**: Separate producers and consumers for better scalability
- **Asynchronous communication**: Non-blocking message processing
- **Event-driven architectures**: Trigger actions based on events
- **Microservices integration**: Connect distributed services reliably
- **Load balancing**: Distribute work across multiple consumers
- **Guaranteed delivery**: Ensure messages are not lost

## Resources Created

- **Azure Service Bus Namespace**: Main namespace for messaging (required)
- **Azure Service Bus Queue**: Queue for point-to-point messaging (required)
- **Azure Service Bus Topic** (optional): Topic for publish-subscribe messaging
- **Azure Service Bus Subscription** (optional): Subscription for the topic

## Messaging Patterns

### Queue (Point-to-Point)

- One message is consumed by exactly one receiver
- Multiple receivers can compete for messages (competing consumers pattern)
- Ideal for: Work distribution, command processing, request-response

### Topic & Subscription (Publish-Subscribe)

- One message can be consumed by multiple subscribers
- Each subscription receives a copy of every message
- Ideal for: Event notifications, broadcasting, fan-out scenarios

## Usage

### Basic Usage

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

### Queue-Only Configuration

```hcl
module "eventbus" {
  source = "./modules/eventbus"

  eventbus_namespace_name = "order-processing-bus"
  eventbus_queue_name     = "order-commands"
  resource_group_name     = var.resource_group_name
  location                = var.location
  eventbus_sku            = "Standard"
  create_topic            = false  # Only create queue
}
```

### Production Configuration

```hcl
module "eventbus" {
  source = "./modules/eventbus"

  eventbus_namespace_name    = "prod-eventbus-${var.environment}"
  eventbus_queue_name        = "high-priority-tasks"
  eventbus_topic_name        = "system-events"
  eventbus_subscription_name = "audit-service-sub"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  eventbus_sku               = "Premium"  # Better performance
  create_topic               = true
  max_size_in_megabytes      = 5120      # 5GB
  max_delivery_count         = 5         # Lower retry count
}
```

### Integration with Quarkus Applications

````hcl
module "eventbus" {
  source = "./modules/eventbus"

  eventbus_namespace_name = "quarkus-app-events"
  eventbus_queue_name     = "user-commands"
  eventbus_topic_name     = "domain-events"
  resource_group_name     = azurerm_resource_group.main.name
  location                = var.location
  eventbus_sku            = "Standard"
  create_topic            = true
}

# Output connection string for use in Quarkus configuration
output "quarkus_servicebus_connection_string" {
  value     = module.eventbus.eventbus_connection_string
  sensitive = true
}
```## Variables

| Name                       | Description                            | Type   | Default                     | Required |
| -------------------------- | -------------------------------------- | ------ | --------------------------- | -------- |
| eventbus_namespace_name    | Name of the Service Bus namespace      | string | "qaz-eventbus-namespace"    | no       |
| eventbus_queue_name        | Name of the Service Bus queue          | string | "qaz-eventbus-queue"        | no       |
| eventbus_topic_name        | Name of the Service Bus topic          | string | "qaz-eventbus-topic"        | no       |
| eventbus_subscription_name | Name of the Service Bus subscription   | string | "qaz-eventbus-subscription" | no       |
| eventbus_sku               | SKU of the Service Bus namespace       | string | "Standard"                  | no       |
| resource_group_name        | Name of the Resource Group             | string | "qz-rg"                     | no       |
| location                   | Location of the Resource Group         | string | "eastus"                    | no       |
| create_topic               | Whether to create a Service Bus topic  | bool   | true                        | no       |
| max_size_in_megabytes      | Maximum size of the queue in megabytes | number | 1024                        | no       |
| max_delivery_count         | Maximum number of delivery attempts    | number | 10                          | no       |

## Outputs

| Name                       | Description                                                 |
| -------------------------- | ----------------------------------------------------------- |
| eventbus_namespace_id      | ID of the Service Bus namespace                             |
| eventbus_namespace_name    | Name of the Service Bus namespace                           |
| eventbus_queue_id          | ID of the Service Bus queue                                 |
| eventbus_queue_name        | Name of the Service Bus queue                               |
| eventbus_topic_id          | ID of the Service Bus topic                                 |
| eventbus_topic_name        | Name of the Service Bus topic                               |
| eventbus_subscription_id   | ID of the Service Bus subscription                          |
| eventbus_subscription_name | Name of the Service Bus subscription                        |
| eventbus_connection_string | Connection string for the Service Bus namespace (sensitive) |

## SKU Options

| SKU | Features | Use Cases |
|-----|----------|-----------|
| **Basic** | • Basic messaging capabilities<br>• Queues only (no topics)<br>• Max 256 KB message size<br>• 1 GB namespace size | • Simple queue scenarios<br>• Development/testing<br>• Cost-sensitive workloads |
| **Standard** | • All Basic features<br>• Topics and subscriptions<br>• Message batching<br>• Scheduled messages<br>• Dead letter queues | • Production workloads<br>• Pub/sub scenarios<br>• Event-driven architectures |
| **Premium** | • All Standard features<br>• Dedicated capacity<br>• Predictable performance<br>• Larger message sizes (100 MB)<br>• Message partitioning | • High-throughput scenarios<br>• Mission-critical applications<br>• Compliance requirements |

## Connection Configuration

### For Quarkus Applications
Add these properties to your `application.properties`:

```properties
# Service Bus connection
quarkus.messaging.outgoing.events.connector=smallrye-servicebus
quarkus.messaging.outgoing.events.connection-string=${SERVICEBUS_CONNECTION_STRING}
quarkus.messaging.outgoing.events.entity-name=your-queue-name

quarkus.messaging.incoming.commands.connector=smallrye-servicebus
quarkus.messaging.incoming.commands.connection-string=${SERVICEBUS_CONNECTION_STRING}
quarkus.messaging.incoming.commands.entity-name=your-queue-name
````

### Environment Variables

Set the connection string as an environment variable:

```bash
export SERVICEBUS_CONNECTION_STRING="$(terraform output -raw eventbus-connection_string)"
```

## Message Patterns

### Command Pattern (Queue)

```java
// Producer
@Channel("commands")
Emitter<String> commandEmitter;

public void sendCommand(String command) {
    commandEmitter.send(command);
}

// Consumer
@Incoming("commands")
public void handleCommand(String command) {
    // Process command
}
```

### Event Pattern (Topic)

```java
// Event Producer
@Channel("events")
Emitter<DomainEvent> eventEmitter;

public void publishEvent(DomainEvent event) {
    eventEmitter.send(event);
}

// Event Consumer
@Incoming("events")
public void handleEvent(DomainEvent event) {
    // Handle event
}
```

## Security Considerations

- **Connection strings are sensitive**: Always store them securely
- **Use managed identities**: For production deployments, consider using managed identities instead of connection strings
- **Network isolation**: Consider private endpoints for enhanced security
- **Access policies**: Use shared access signatures (SAS) for fine-grained access control

## Monitoring and Troubleshooting

### Key Metrics to Monitor

- **Message count**: Number of messages in queues/topics
- **Dead letter count**: Messages that failed processing
- **Throttling**: Rate limiting indicators
- **Connection errors**: Authentication/network issues

### Common Issues

- **Message size limits**: Ensure messages don't exceed SKU limits
- **Dead letter handling**: Implement dead letter queue processing
- **Connection management**: Properly manage connection lifecycle
- **Duplicate detection**: Configure if needed for exactly-once processing

## Best Practices

1. **Use appropriate SKU**: Choose based on throughput and feature requirements
2. **Implement retry logic**: Handle transient failures gracefully
3. **Set up dead letter queues**: Handle failed messages appropriately
4. **Monitor message metrics**: Track performance and health
5. **Use correlation IDs**: For message tracing and debugging
6. **Implement circuit breakers**: Prevent cascade failures
7. **Configure auto-scaling**: For consumer applications

## Notes

- The module creates a queue by default for point-to-point messaging
- Topic and subscription creation is controlled by the `create_topic` variable
- Connection strings are marked as sensitive and will not be displayed in logs
- The module follows Azure naming conventions and best practices
- Default message TTL is set to maximum (10675199 days) for topics and subscriptions
- Queue maximum delivery count is configurable (default: 10)
- Duplicate detection is disabled by default but can be enabled if needed
