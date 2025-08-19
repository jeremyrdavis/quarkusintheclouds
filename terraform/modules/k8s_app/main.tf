resource "kubernetes_namespace" "app" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_config_map" "app_config" {
  metadata {
    name      = "app-config"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  data = var.config_data
}

resource "kubernetes_deployment" "back" {
  metadata {
    name      = "back"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = "back"
    }
  }
  spec {
    replicas = var.back_replicas
    selector {
      match_labels = {
        app = "back"
      }
    }
    template {
      metadata {
        labels = {
          app = "back"
        }
      }
      spec {
        container {
          name  = "back"
          image = var.back_image
          env_from {
            config_map_ref {
              name = kubernetes_config_map.app_config.metadata[0].name
            }
          }
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "back" {
  metadata {
    name      = "back"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    selector = {
      app = "back"
    }
    port {
      port        = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "front" {
  metadata {
    name      = "front"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = "front"
    }
  }
  spec {
    replicas = var.front_replicas
    selector {
      match_labels = {
        app = "front"
      }
    }
    template {
      metadata {
        labels = {
          app = "front"
        }
      }
      spec {
        container {
          name  = "front"
          image = var.front_image
          env_from {
            config_map_ref {
              name = kubernetes_config_map.app_config.metadata[0].name
            }
          }
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "front" {
  metadata {
    name      = "front"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    selector = {
      app = "front"
    }
    port {
      port        = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "front_ingress" {
  metadata {
    name      = "front-ingress"
    namespace = kubernetes_namespace.app.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    rule {
      http {
        path {
          path     = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.front.metadata[0].name
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "back_ingress" {
  metadata {
    name      = "back-ingress"
    namespace = kubernetes_namespace.app.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    rule {
      http {
        path {
          path     = "/api"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.back.metadata[0].name
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}
