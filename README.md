# Quarkus in the Clouds

A collection of Quarkus applications demonstrating cloud-native development with Azure services, including CosmosDB integration, Azure Functions, and container deployment examples.

## Projects Overview

### =' Azure Verification (`azure-verification/`)
**Purpose**: Comprehensive Azure services integration testing application  
**Tech Stack**: Quarkus 3.17.6, Java 21  
**Azure Services**: CosmosDB, Key Vault, Event Hubs, App Configuration, Blob Storage  

**Run Instructions**:
```bash
cd azure-verification
./mvnw quarkus:dev
```

### =� Quarkus Affirmations Backend (`quarkus-affirmations-backend/`)
**Purpose**: REST API backend for affirmations with CosmosDB persistence  
**Tech Stack**: Quarkus 3.17.7, Java 21, Azure CosmosDB  
**Port**: Default Quarkus port (8080)

**Run Instructions**:
```bash
cd quarkus-affirmations-backend
# Set environment variables
export QUARKUS_AZURE_COSMOS_ENDPOINT=your_cosmos_endpoint
export QUARKUS_AZURE_COSMOS_KEY=your_cosmos_key
./mvnw quarkus:dev
```

### =� Quarkus Affirmations Frontend (`quarkus-affirmations-frontend/`)
**Purpose**: Web frontend consuming the affirmations backend API  
**Tech Stack**: Quarkus 3.21.0, Java 21, REST Client, Kubernetes support  
**Port**: Development mode runs on port 8080

**Run Instructions**:
```bash
cd quarkus-affirmations-frontend
# For development (connects to localhost:8088)
./mvnw quarkus:dev

# For production, set API_BASE_URL environment variable
export API_BASE_URL=https://your-backend-url
./mvnw quarkus:dev
```

### � Quarkus Azure Function (`quarkus-azure-function/`)
**Purpose**: Quarkus application packaged as Azure Functions  
**Tech Stack**: Quarkus 3.18.1, Java 21  

**Run Instructions**:
```bash
cd quarkus-azure-function
./mvnw quarkus:dev
```

### =' Quarkus Azure Function Custom Handler (`quarkus-azure-function-custom-handler/`)
**Purpose**: Custom handler implementation for Azure Functions  
**Contains**: Pre-compiled handler executable and function configuration

**Run Instructions**:
```bash
cd quarkus-azure-function-custom-handler
# Requires Azure Functions Core Tools
func start
```

### < CosmosDB Quickstart (`cosmosdb-quickstart/`)
**Purpose**: Spring Boot application demonstrating Azure CosmosDB integration  
**Tech Stack**: Spring Boot 3.2.0, Java 21, Azure Spring Data Cosmos  
**Note**: This is a Spring Boot project (not Quarkus)

**Run Instructions**:
```bash
cd cosmosdb-quickstart/src
# Requires Docker for local CosmosDB emulator
docker run -p 8081:8081 -p 10251:10251 -p 10252:10252 -p 10253:10253 -p 10254:10254 -e AZURE_COSMOS_EMULATOR_PARTITION_COUNT=10 -e AZURE_COSMOS_EMULATOR_ENABLE_DATA_PERSISTENCE=true mcr.microsoft.com/cosmosdb/linux/azure-cosmos-emulator
mvn spring-boot:run
```

### <� Infrastructure (`terraform/`)
**Purpose**: Terraform modules for Azure infrastructure provisioning  
**Modules**: AKS, App Configuration, Blob Storage, Container Apps, CosmosDB, Event Hubs, Key Vault

**Available Modules**:
- `aks/` - Azure Kubernetes Service
- `appconfig/` - Azure App Configuration
- `blobstorage/` - Azure Blob Storage
- `containerapps/` - Azure Container Apps
- `cosmosdb/` - Azure CosmosDB
- `cosmosdb-dev/` - CosmosDB development environment
- `eventhubs/` - Azure Event Hubs
- `keyvault/` - Azure Key Vault

### =� Azure Functions (`hello-function/`, `quarkus-affirmations-frontend-function/`)
**Purpose**: Standalone Azure Function implementations

## Prerequisites

- **Java 21** - All Quarkus projects use Java 21
- **Maven** - For building and running projects
- **Docker** - For containerization and local services
- **Azure CLI** - For Azure resource management
- **Terraform** - For infrastructure provisioning (optional)

## Quick Start

1. **Start with the backend**:
   ```bash
   cd quarkus-affirmations-backend
   ./mvnw quarkus:dev
   ```

2. **Run the frontend** (in a new terminal):
   ```bash
   cd quarkus-affirmations-frontend
   ./mvnw quarkus:dev
   ```

3. **Test Azure integrations**:
   ```bash
   cd azure-verification
   ./mvnw quarkus:dev
   ```

## Development Workflow

### Running Tests
```bash
# In any Quarkus project directory
./mvnw test
```

### Building for Production
```bash
# Standard JAR
./mvnw package

# Native executable (requires GraalVM)
./mvnw package -Pnative
```

### Docker Builds
Each Quarkus project includes Dockerfiles in `src/main/docker/`:
- `Dockerfile.jvm` - Standard JVM build
- `Dockerfile.native` - Native executable build
- `Dockerfile.legacy-jar` - Legacy JAR format
- `Dockerfile.native-micro` - Minimal native build

## Configuration

### Environment Variables
- `QUARKUS_AZURE_COSMOS_ENDPOINT` - CosmosDB endpoint URL
- `QUARKUS_AZURE_COSMOS_KEY` - CosmosDB access key
- `API_BASE_URL` - Backend API URL for frontend

### Development Ports
- Backend: 8088 (dev mode)
- Frontend: 8080 (dev mode)
- Azure Verification: 8080 (dev mode)

## Architecture

```
                                               
  Frontend (Web UI)         Backend (API)      
  Port: 8080            �   Port: 8088         
  Quarkus 3.21.0            Quarkus 3.17.7     
                                               
                                        
                                        �
                                                 
                              Azure CosmosDB     
                              (Affirmations)     
                                                 
```

## Deployment

### Azure Container Apps
Use the Terraform modules in `terraform/modules/containerapps/` for deployment.

### Kubernetes
The frontend project includes Kubernetes manifests generated by Quarkus.

### Azure Functions
Deploy using Azure Functions Core Tools or Azure DevOps pipelines.

## Contributing

1. Each project follows standard Quarkus conventions
2. Use Java 21 language features
3. Follow the existing package structure
4. Add tests for new functionality
5. Update documentation as needed