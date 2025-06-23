# Azure Red Hat OpenShift (ARO) Module

This Terraform module creates an Azure Red Hat OpenShift (ARO) cluster with the necessary networking infrastructure and automatically creates a service principal for cluster management.

## Features

- Creates a virtual network with master and worker subnets
- Automatically creates a service principal with Contributor role
- Deploys an Azure Red Hat OpenShift cluster
- Configures public API server and ingress profiles
- Returns cluster credentials and connection information

## Requirements

- Azure subscription with ARO provider enabled
- Azure AD permissions to create service principals
- Resource group must be created by the parent module

## Usage

```hcl
module "aro" {
  source = "./modules/aro"

  location            = "eastus"
  resource_group_name = azurerm_resource_group.main.name
  resource_group_id   = azurerm_resource_group.main.id
  random_num          = random_integer.num.result

  domain = "mycluster"

  worker_node_count = 3
  master_vm_size    = "Standard_D8s_v3"
  worker_vm_size    = "Standard_D4s_v3"

  tags = {
    Environment = "Production"
    Project     = "Quarkus"
  }
}
```

## Inputs

| Name                | Description                     | Type          | Default                | Required |
| ------------------- | ------------------------------- | ------------- | ---------------------- | :------: |
| location            | Location of the ARO cluster     | `string`      | `"eastus"`             |    no    |
| resource_group_name | Name of the resource group      | `string`      | n/a                    |   yes    |
| resource_group_id   | Resource group ID               | `string`      | n/a                    |   yes    |
| random_num          | Random number for unique naming | `string`      | n/a                    |   yes    |
| domain              | Domain for the ARO cluster      | `string`      | `"quarkusintheclouds"` |    no    |
| master_vm_size      | VM size for master nodes        | `string`      | `"Standard_D8s_v3"`    |    no    |
| worker_vm_size      | VM size for worker nodes        | `string`      | `"Standard_D4s_v3"`    |    no    |
| worker_node_count   | Number of worker nodes          | `number`      | `3`                    |    no    |
| worker_disk_size_gb | Disk size for worker nodes      | `number`      | `128`                  |    no    |
| tags                | Tags to apply to resources      | `map(string)` | `{}`                   |    no    |

## Outputs

| Name                        | Description                                        |
| --------------------------- | -------------------------------------------------- |
| cluster_name                | Name of the ARO cluster                            |
| cluster_id                  | ID of the ARO cluster                              |
| console_url                 | URL of the OpenShift console                       |
| cluster_info                | Basic cluster information (name, id, console_url)  |
| service_principal_client_id | Client ID of the service principal created for ARO |
| service_principal_object_id | Object ID of the service principal created for ARO |
| virtual_network_id          | ID of the virtual network                          |
| master_subnet_id            | ID of the master subnet                            |
| worker_subnet_id            | ID of the worker subnet                            |

## Notes

- The resource group must be created by the parent module
- The module automatically creates a service principal with Contributor role on the resource group
- The module creates a virtual network with CIDR 10.0.0.0/23
- Master subnet uses 10.0.0.0/27 and worker subnet uses 10.0.0.128/25
- Pod CIDR is set to 10.128.0.0/14 and service CIDR to 172.30.0.0/16
- After deployment, you can access the cluster using the console URL
- Default username for ARO is typically "kubeadmin"
