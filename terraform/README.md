# Terraform

If you need to install Terraform: https://developer.hashicorp.com/terraform/install

Terraform will create the resuource group with a randomly generated number so that you can run this multiple times.

Log into Azure and export your subscription ID and tenant ID

```bash
export TF_VAR_subscription_id=$(az account show --query id -o tsv)
export TF_VAR_tenant_id=$(az account show --query tenantId -o tsv)
```

**Note**: The ARO module automatically creates its own service principal, so no manual service principal creation is required.

**Important**: You need a Red Hat pull secret for the ARO cluster. You can get this from the Red Hat OpenShift Cluster Manager:

```bash
# Set the Red Hat pull secret
export TF_VAR_aro_pull_secret='{"auths":{"fake":{"auth":"fake"}}}'
```

From the src/main/terraform directory, run the following commands to create the resources in Azure:

```bash
terraform init
terraform plan -out quarkusinazure.plan
terraform apply "quarkusinazure.plan"
```

Don't forget to destroy your resources when you are done, and note that it can take a while for CosmosDB to delete:

```bash
terraform destroy
```

## Modules

This Terraform configuration includes the following modules:

- **AKS**: Azure Kubernetes Service cluster
- **ARO**: Azure Red Hat OpenShift cluster (automatically creates service principal)
- **AppConfig**: Azure App Configuration
- **BlobStorage**: Azure Blob Storage
- **CosmosDB**: Azure Cosmos DB
- **EventBus**: Azure Service Bus for event-driven messaging
- **EventHubs**: Azure Event Hubs
- **KeyVault**: Azure Key Vault
- **ContainerApps**: Azure Container Apps

## ARO Cluster Access

After deployment, you can access the OpenShift cluster using the console URL from the Terraform outputs:

```bash
# Get the cluster information
terraform output aro-cluster_info

# Access the OpenShift console
terraform output aro-console_url

# View the service principal information (if needed)
terraform output aro-service_principal_client_id
```

The default username for ARO clusters is typically "kubeadmin". You can retrieve the password from the Azure portal or use the Azure CLI:

```bash
# Get the cluster credentials from Azure CLI
az aro list-credentials --name <cluster-name> --resource-group <resource-group-name>
```

## EventBus Module

The EventBus module creates an Azure Service Bus namespace with queues and topics for event-driven messaging:

```bash
# Get the EventBus connection information
terraform output eventbus-namespace_name
terraform output eventbus-queue_name
terraform output eventbus-topic_name

# Get the connection string (sensitive)
terraform output eventbus-connection_string
```

The EventBus is ideal for:

- **Microservices communication**: Reliable message passing between services
- **Event-driven architectures**: Trigger actions based on events
- **Asynchronous processing**: Non-blocking message processing
- **Load balancing**: Distribute work across multiple consumers

### Using with Quarkus Applications

Set the connection string as an environment variable:

```bash
export SERVICEBUS_CONNECTION_STRING="$(terraform output -raw eventbus-connection_string)"
```

Add to your `application.properties`:

```properties
quarkus.messaging.outgoing.events.connector=smallrye-servicebus
quarkus.messaging.outgoing.events.connection-string=${SERVICEBUS_CONNECTION_STRING}
quarkus.messaging.outgoing.events.entity-name=your-queue-name
```

## Red Hat Pull Secret

The ARO cluster requires a Red Hat pull secret to access Red Hat container images. You can obtain this from:

1. **Red Hat OpenShift Cluster Manager**: https://console.redhat.com/openshift/install/azure/installer-provisioned
2. **Red Hat Customer Portal**: https://access.redhat.com/

The pull secret should be provided as a JSON string containing authentication information for Red Hat registries.
