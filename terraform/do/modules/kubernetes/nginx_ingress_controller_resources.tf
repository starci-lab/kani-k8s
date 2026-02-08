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
// Read NGINX Ingress Controller Service
// =========================
// Fetches the Service created by the Helm chart.
// This data source is commonly used to retrieve the external LoadBalancer IP,
// which can then be published via DNS (e.g., Cloudflare A records).
data "kubernetes_service" "nginx_ingress_controller" {
  metadata {
    name      = local.nginx_ingress_controller.name
    namespace = kubernetes_namespace.nginx_ingress_controller.metadata[0].name
  }

  // Ensure Helm has installed the ingress controller before reading the Service
  depends_on = [helm_release.nginx_ingress_controller]
}
