// =========================
// Namespace for Prometheus
// =========================
// Creates a dedicated namespace to isolate the Prometheus
// and its related resources from application workloads.
resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "prometheus"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}
