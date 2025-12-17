# Create namespace for the nginx ingress controller
resource "kubernetes_namespace" "nginx_ingress_controller" {
  metadata {
    name = "nginx-ingress-controller"
  }
  depends_on = [ digitalocean_kubernetes_cluster.kubernetes ]
}

locals {
  nginx_ingress_controller_name = "nginx-ingress-controller"
}

# Nginx Ingress Controller
resource "helm_release" "nginx_ingress_controller" {
  name             = local.nginx_ingress_controller_name
  namespace        = kubernetes_namespace.nginx_ingress_controller.metadata[0].name
  chart = "oci://registry-1.docker.io/bitnamicharts/nginx-ingress-controller"

   values = [
    templatefile("${path.module}/yamls/nginx-ingress-controller.yaml", {
      node_pool_label = var.kubernetes_node_pool_name
      request_cpu  = var.nginx_ingress_controller_request_cpu
      request_memory = var.nginx_ingress_controller_request_memory
      limit_cpu    = var.nginx_ingress_controller_limit_cpu
      limit_memory = var.nginx_ingress_controller_limit_memory
      default_backend_request_cpu  = var.nginx_ingress_controller_default_backend_request_cpu
      default_backend_request_memory = var.nginx_ingress_controller_default_backend_request_memory
      default_backend_limit_cpu    = var.nginx_ingress_controller_default_backend_limit_cpu
      default_backend_limit_memory = var.nginx_ingress_controller_default_backend_limit_memory
    })
  ]
  depends_on = [
    kubernetes_namespace.nginx_ingress_controller
  ]
}

data "kubernetes_service" "nginx_ingress_controller" {
  metadata {
    name = local.nginx_ingress_controller_name
    namespace = kubernetes_namespace.nginx_ingress_controller.metadata[0].name
  }
  depends_on = [ helm_release.nginx_ingress_controller ]
}