// =========================
// Namespace for NGINX Ingress Controller
// =========================
// Creates a dedicated namespace to isolate the NGINX Ingress Controller
// and its related resources from application workloads.
resource "kubernetes_namespace" "nginx_ingress_controller" {
  metadata {
    name = "nginx-ingress-controller"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// Local identifiers
// =========================
// Defines shared names used by the Helm release and Service lookup.
locals {
  nginx_ingress_controller_name = "nginx-ingress-controller"
}

// =========================
// NGINX Ingress Controller Helm release
// =========================
// Deploys the NGINX Ingress Controller using the Bitnami OCI Helm chart.
// Configuration is injected via a Terraform-rendered values file, including:
// - Resource requests/limits for the controller and default backend
// - Node scheduling to a specific node pool (via node labels)
resource "helm_release" "nginx_ingress_controller" {
  name      = local.nginx_ingress_controller_name
  namespace = kubernetes_namespace.nginx_ingress_controller.metadata[0].name

  // Bitnami NGINX Ingress Controller chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/nginx-ingress-controller"

  // Render Helm values from a Terraform template and inject variables
  values = [
    templatefile("${path.module}/yamls/nginx-ingress-controller.yaml", {

      // =========================
      // Node scheduling
      // =========================
      // Ensures ingress pods are scheduled onto the primary node pool
      node_pool_label = var.kubernetes_primary_node_pool_name

      // =========================
      // Controller resources
      // =========================
      replica_count = var.nginx_ingress_controller_replica_count
      request_cpu    = var.nginx_ingress_controller_request_cpu
      request_memory = var.nginx_ingress_controller_request_memory
      limit_cpu      = var.nginx_ingress_controller_limit_cpu
      limit_memory   = var.nginx_ingress_controller_limit_memory

      // =========================
      // Default backend resources
      // =========================
      // Serves fallback responses (e.g., 404) when no ingress rule matches
      default_backend_request_cpu    = var.nginx_ingress_controller_default_backend_request_cpu
      default_backend_request_memory = var.nginx_ingress_controller_default_backend_request_memory
      default_backend_limit_cpu      = var.nginx_ingress_controller_default_backend_limit_cpu
      default_backend_limit_memory   = var.nginx_ingress_controller_default_backend_limit_memory
    })
  ]

  // Ensure the namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.nginx_ingress_controller
  ]
}

// =========================
// Read NGINX Ingress Controller Service
// =========================
// Fetches the Service created by the Helm chart.
// This data source is commonly used to retrieve the external LoadBalancer IP,
// which can then be published via DNS (e.g., Cloudflare A records).
data "kubernetes_service" "nginx_ingress_controller" {
  metadata {
    name      = local.nginx_ingress_controller_name
    namespace = kubernetes_namespace.nginx_ingress_controller.metadata[0].name
  }

  // Ensure Helm has installed the ingress controller before reading the Service
  depends_on = [helm_release.nginx_ingress_controller]
}