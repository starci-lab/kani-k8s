// =========================
// NGINX Ingress Controller Helm release
// =========================
// Deploys the NGINX Ingress Controller using the Bitnami OCI Helm chart.
// Configuration is injected via a Terraform-rendered values file, including:
// - Resource requests/limits for the controller and default backend
// - Node scheduling to a specific node pool (via node labels)
resource "helm_release" "nginx_ingress_controller" {
  name      = local.nginx_ingress_controller.name
  namespace = kubernetes_namespace.nginx_ingress_controller.metadata[0].name

  // Bitnami NGINX Ingress Controller chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/nginx-ingress-controller"

  // Render Helm values from a Terraform template and inject variables
  values = [
    templatefile("${path.module}/yamls/nginx-ingress-controller.yaml", {
      // Node scheduling
      node_pool_label = var.kubernetes_primary_node_pool_name
      // Controller resources
      replica_count                       = var.nginx_ingress_controller_replica_count
      default_backend_replica_count       = var.nginx_ingress_controller_default_backend_replica_count
      request_cpu    = local.nginx_ingress_controller.controller.request_cpu
      request_memory = local.nginx_ingress_controller.controller.request_memory
      limit_cpu      = local.nginx_ingress_controller.controller.limit_cpu
      limit_memory   = local.nginx_ingress_controller.controller.limit_memory
      // Default backend resources
      default_backend_request_cpu    = local.nginx_ingress_controller.default_backend.request_cpu
      default_backend_request_memory = local.nginx_ingress_controller.default_backend.request_memory
      default_backend_limit_cpu      = local.nginx_ingress_controller.default_backend.limit_cpu
      default_backend_limit_memory   = local.nginx_ingress_controller.default_backend.limit_memory
    })
  ]

  // Ensure the namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.nginx_ingress_controller
  ]
}
