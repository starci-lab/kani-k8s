// =========================
// Namespace for Consul
// =========================
// Creates a dedicated namespace for HashiCorp Consul resources.
resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// Consul Service (data)
// =========================
// Fetches the Service created by the Consul Helm chart.
data "kubernetes_service" "consul" {
  metadata {
    name      = local.consul.server_service_name
    namespace = kubernetes_namespace.consul.metadata[0].name
  }

  depends_on = [helm_release.consul]
}
