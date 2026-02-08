// =========================
// Namespace for Grafana
// =========================
// Creates a dedicated namespace to isolate Grafana
// and its related resources from application workloads.
resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "grafana"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

