output "namespace" {
  value = kubernetes_namespace.app.metadata[0].name
}

output "front_service_name" {
  value = kubernetes_service.front.metadata[0].name
}

output "back_service_name" {
  value = kubernetes_service.back.metadata[0].name
}

output "front_ingress_name" {
  value = kubernetes_ingress_v1.front_ingress.metadata[0].name
}

output "back_ingress_name" {
  value = kubernetes_ingress_v1.back_ingress.metadata[0].name
}
