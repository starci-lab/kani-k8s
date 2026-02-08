// =========================
// Namespace for Loki
// =========================
// Creates a dedicated namespace for Loki resources.
resource "kubernetes_namespace" "loki" {
  metadata {
    name = "loki"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

