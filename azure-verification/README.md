# quarkusonazure

This project uses Quarkus, the Supersonic Subatomic Java Framework.

If you want to learn more about Quarkus, please visit its website: <https://quarkus.io/>.

## Local Developments

Install the CosmosDB emulator: https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-develop-emulator
For Apple Silicon: https://learn.microsoft.com/en-us/azure/cosmos-db/emulator-linux

You will need Docker or Podman Desktop to run the CosmosDB emulator.

```bash

## Azure Set Up

### Terraform
If you need to install Terraform: https://developer.hashicorp.com/terraform/install

Terraform will create the resuource group with a randomly generated number so that you can run this multiple times.

Log into Azure and export your subscription ID and tenant ID
```bash
export TF_VAR_subscription_id=$(az account show --query id -o tsv)
export TF_VAR_tenant_id=$(az account show --query tenantId -o tsv)
```

From the src/main/terraform directory, run the following commands to create the resources in Azure:

```bash
terraform init
terraform plan -out terraform.plan
terraform apply "terraform.plan"
 ```

Don't forget to destroy your resources when you are done, and note that it can take a while for CosmosDB to delete:

```bash 
terraform destroy
```

### Azure CLI (the hard way)

```bash
export AZURE_RESOURCE_GROUP=rg-quarkus-in-azure-demo \
export LOCATION=eastus \
export REGION_NAME='East US' \
export AZURE_APP_CONFIG=quarkus-azure-app-config \
export COSMOS_ACCOUNT=quarkusaccount \
export COSMOS_DB_NAME=quarkusdb \
export COSMOS_CONTAINER_NAME=quarkuscontainer \
export EVENTHUBS_NAMESPACE=quarkuseventhubnamespace \
export EVENTHUBS_NAME=quarkuseventhub \
export KEYVAULT_NAME=quarkusazurekeyvault \
export KEYVUALT_SECRET_NAME=secret2 \
export KEYVAULT_SECRET_VALUE=myothersecret \
export BLOB_STORAGE_NAME=quarkusblob

echo $AZURE_RESOURCE_GROUP \
echo $LOCATION $REGION_NAME \
echo $COSMOS_DB_NAME \
echo $COSMOS_CONTAINER_NAME \
echo $EVENTHUBS_NAMESPACE \
echo $EVENTHUBS_NAME \
echo $KEYVAULT_NAME \
echo $KEYVUALT_SECRET_NAME \
echo $KEYVAULT_SECRET_VALUE

# App Config
az group create \
    --name $AZURE_RESOURCE_GROUP \
    --location eastus
    
az appconfig create \
    --name $AZURE_APP_CONFIG \
    --resource-group $AZURE_RESOURCE_GROUP \
    --location $LOCATION
    
az appconfig kv set --name $AZURE_APP_CONFIG --yes --key myKeyOne --value "Tuesday" \
az appconfig kv set --name $AZURE_APP_CONFIG --yes --key myKeyTwo --value "Morning" \
az appconfig kv list --name $AZURE_APP_CONFIG

export QUARKUS_AZURE_APP_CONFIGURATION_ENDPOINT=$(az appconfig show \
  --resource-group $AZURE_RESOURCE_GROUP \
  --name $AZURE_APP_CONFIG \
  --query endpoint -o tsv)
  
 # Retrieve the app configuration resource ID
APP_CONFIGURATION_RESOURCE_ID=$(az appconfig show \
    --resource-group $AZURE_RESOURCE_GROUP \
    --name $AZURE_APP_CONFIG \
    --query 'id' \
    --output tsv)
# Assign the "App Configuration Data Reader" role to the current signed-in identity
az role assignment create \
    --assignee $(az ad signed-in-user show --query 'id' --output tsv) \
    --role "App Configuration Data Reader" \
    --scope $APP_CONFIGURATION_RESOURCE_ID

credential=$(az appconfig credential list \
    --name $AZURE_APP_CONFIG \
    --resource-group $AZURE_RESOURCE_GROUP \
    | jq 'map(select(.readOnly == true)) | .[0]')
export QUARKUS_AZURE_APP_CONFIGURATION_ID=$(echo "${credential}" | jq -r '.id')
export QUARKUS_AZURE_APP_CONFIGURATION_SECRET=$(echo "${credential}" | jq -r '.value')    
    

# CosmosDB
# Create the account
az cosmosdb create \
    -n $COSMOS_ACCOUNT \
    -g $AZURE_RESOURCE_GROUP \
    --default-consistency-level Session \
    --locations regionName=$REGION_NAME failoverPriority=0 isZoneRedundant=False

# Create the database    
az cosmosdb sql database create \
    -a $COSMOS_ACCOUNT \
    -g $AZURE_RESOURCE_GROUP \
    -n $COSMOS_DB_NAME

# Create the container    
az cosmosdb sql container create \
    -a $COSMOS_ACCOUNT \
    -g $AZURE_RESOURCE_GROUP \
    -d $COSMOS_DB_NAME \
    -n $COSMOS_CONTAINER_NAME \
    -p "/id"

# Get the endpoint    
export QUARKUS_AZURE_COSMOS_ENDPOINT=$(az cosmosdb show \
    -n $COSMOS_ACCOUNT \
    -g $AZURE_RESOURCE_GROUP \
    --query documentEndpoint -o tsv)
    
# Assign the Cosmos DB Built-in Data Contributor role to the signed-in user as a Microsoft Entra identity.
az ad signed-in-user show --query id -o tsv \
    | az cosmosdb sql role assignment create \
    --account-name $COSMOS_ACCOUNT \
    --resource-group $AZURE_RESOURCE_GROUP \
    --scope "/" \
    --principal-id @- \
    --role-definition-id 00000000-0000-0000-0000-000000000002
    
# Export the key of the Azure Cosmos DB account as an environment variable.
export QUARKUS_AZURE_COSMOS_KEY=$(az cosmosdb keys list \
    -n $COSMOS_ACCOUNT \
    -g $AZURE_RESOURCE_GROUP \
    --query primaryMasterKey -o tsv)

# Event Hubs
az eventhubs namespace create \
    --name $EVENT_HUBS_NAMESPACE \
    --resource-group $AZURE_RESOURCE_GROUP

az eventhubs eventhub create \
    --name $EVENTHUBS_NAME \
    --namespace-name $EVENTHUBS_NAMESPACE \
    --resource-group $AZURE_RESOURCE_GROUP \
    --partition-count 2
    
export EVENTHUBS_EVENTHUB_RESOURCE_ID=$(az eventhubs eventhub show \
--resource-group $AZURE_RESOURCE_GROUP \
--namespace-name EVENTHUBS_NAMESPACE \
--name $EVENTHUBS_NAME \
--query 'id' \
--output tsv)

az role assignment create \
    --role "Azure Event Hubs Data Owner" \
    --assignee $(az ad signed-in-user show --query 'id' --output tsv) \
    --scope $EVENTHUBS_EVENTHUB_RESOURCE_ID

export QUARKUS_AZURE_EVENTHUBS_NAMESPACE=$EVENTHUBS_NAMESPACE
export QUARKUS_AZURE_EVENTHUBS_EVENTHUB_NAME=$EVENTHUBS_EVENTHUB_NAME

# Key Vault
az keyvault create --name $KEYVAULT_NAME \
    --resource-group $AZURE_RESOURCE_GROUP \
    --location $LOCATION \
    --enable-rbac-authorization false

az keyvault secret set \
    --vault-name $KEYVAULT_NAME \
    --name $KEYVUALT_SECRET_NAME \
    --value $KEYVAULT_SECRET_VALUE
    
export QUARKUS_AZURE_KEYVAULT_SECRET_ENDPOINT=$(az keyvault show --name $KEYVAULT_NAME \
    --resource-group $AZURE_RESOURCE_GROUP \
    --query properties.vaultUri \
    --output tsv)
    
# Blob Storage
az storage account create \
    --name $BLOB_STORAGE_NAME \
    --resource-group $AZURE_RESOURCE_GROUP \
    --location $LOCATION \
    --sku Standard_ZRS \
    --encryption-services blob

# Retrieve the storage account resource ID
STORAGE_ACCOUNT_RESOURCE_ID=$(az storage account show \
    --resource-group $AZURE_RESOURCE_GROUP \
    --name $BLOB_STORAGE_NAME \
    --query 'id' \
    --output tsv)

# Assign the "Storage Blob Data Contributor" role to the current signed-in identity
az role assignment create \
    --assignee $(az ad signed-in-user show --query 'id' --output tsv) \
    --role "Storage Blob Data Contributor" \
    --scope $STORAGE_ACCOUNT_RESOURCE_ID

export QUARKUS_AZURE_STORAGE_BLOB_ENDPOINT=$(az storage account show \
    --resource-group $AZURE_RESOURCE_GROUP \
    --name $BLOB_STORAGE_NAME \
    --query 'primaryEndpoints.blob' \
    --output tsv)
echo "QUARKUS_AZURE_STORAGE_BLOB_ENDPOINT is: ${QUARKUS_AZURE_STORAGE_BLOB_ENDPOINT}"

export QUARKUS_AZURE_STORAGE_BLOB_CONNECTION_STRING=$(az storage account show-connection-string \
    --resource-group $AZURE_RESOURCE_GROUP \
    --name $BLOB_STORAGE_NAME \
    --output tsv)
echo "QUARKUS_AZURE_STORAGE_BLOB_CONNECTION_STRING is: ${QUARKUS_AZURE_STORAGE_BLOB_CONNECTION_STRING}"
```
## Running the application in dev mode

You can run your application in dev mode that enables live coding using:

```shell script
./mvnw compile quarkus:dev
```

## Endpoints
http://localhost:8080/keyvault


> **_NOTE:_**  Quarkus now ships with a Dev UI, which is available in dev mode only at <http://localhost:8080/q/dev/>.

## Packaging and running the application

The application can be packaged using:

```shell script
./mvnw package
```

It produces the `quarkus-run.jar` file in the `target/quarkus-app/` directory.
Be aware that it’s not an _über-jar_ as the dependencies are copied into the `target/quarkus-app/lib/` directory.

The application is now runnable using `java -jar target/quarkus-app/quarkus-run.jar`.

If you want to build an _über-jar_, execute the following command:

```shell script
./mvnw package -Dquarkus.package.jar.type=uber-jar
```

The application, packaged as an _über-jar_, is now runnable using `java -jar target/*-runner.jar`.

## Creating a native executable

You can create a native executable using:

```shell script
./mvnw package -Dnative
```

Or, if you don't have GraalVM installed, you can run the native executable build in a container using:

```shell script
./mvnw package -Dnative -Dquarkus.native.container-build=true
```

You can then execute your native executable with: `./target/quarkusonazure-0.0.1-SNAPSHOT-runner`

If you want to learn more about building native executables, please consult <https://quarkus.io/guides/maven-tooling>.

## Related Guides

- REST Jackson ([guide](https://quarkus.io/guides/rest#json-serialisation)): Jackson serialization support for Quarkus REST. This extension is not compatible with the quarkus-resteasy extension, or any of the extensions that depend on it

## Provided Code

### REST

Easily start your REST Web Services

[Related guide section...](https://quarkus.io/guides/getting-started-reactive#reactive-jax-rs-resources)
