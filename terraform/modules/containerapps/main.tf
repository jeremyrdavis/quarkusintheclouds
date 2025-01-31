resource "azurerm_container_app_environment" "example" {
  name                = var.environment_name
  location            = var.location
  resource_group_name = var.resource_group_name

}

resource "azurerm_container_app" "frontend" {
  name                = "quarkus-affirmations-frontend"
  container_app_environment_id = azurerm_container_app_environment.example.id
  resource_group_name = var.resource_group_name
  revision_mode = "Single"
  

  template {
    container {
      name   = "frontend"
      image  = "jeremydavis/quarkus-affirmations-frontend:1.1"
      cpu    = "0.5"
      memory = "1.0Gi"
      env {
        name  = "API_BASE_URL"
        value = "https://${azurerm_container_app.backend.latest_revision_fqdn}"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8080

    traffic_weight {
      percentage = 100
      revision_suffix = "v1"
    }
  }
}

resource "azurerm_container_app" "backend" {
  name                = "quarkus-affirmations-backend"
  container_app_environment_id = azurerm_container_app_environment.example.id
  resource_group_name = var.resource_group_name
  revision_mode = "Single"

  template {
    container {
      name   = "backend"
      image  = "jeremydavis/quarkus-affirmations-backend:1.1"
      cpu    = "0.5"
      memory = "1.0Gi"
    }
  }
  ingress {
    external_enabled = true
    target_port      = 8080

    traffic_weight {
      percentage = 100
      revision_suffix = "v1"
    }
  }
}

