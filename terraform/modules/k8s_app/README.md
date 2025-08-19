# k8s_app module

This module provisions the following Kubernetes resources using the official Terraform Kubernetes provider:
- Namespace
- ConfigMap
- Backend Deployment, Service, and Ingress
- Frontend Deployment, Service, and Ingress

## Variables
- `namespace`: Namespace to deploy resources into (default: `default`)
- `back_image`: Backend container image
- `front_image`: Frontend container image
- `back_replicas`: Backend replica count (default: 1)
- `front_replicas`: Frontend replica count (default: 1)
- `config_data`: Map of config values for the ConfigMap

## Example Usage

```
module "k8s_app" {
  source        = "./modules/k8s_app"
  namespace     = "myapp"
  back_image    = "myrepo/back:latest"
  front_image   = "myrepo/front:latest"
  back_replicas = 2
  front_replicas = 2
  config_data   = {
    SOME_KEY = "some_value"
  }
}
```

## Provider
You must configure the `kubernetes` provider in your root module, e.g.:

```
provider "kubernetes" {
  config_path = "~/.kube/config"
}
```
