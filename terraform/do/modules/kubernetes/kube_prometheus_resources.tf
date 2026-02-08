// =========================
// Namespace for kube-prometheus
// =========================
// Creates a dedicated namespace to isolate the kube-prometheus
// and its related resources from application workloads.
resource "kubernetes_namespace" "kube_prometheus" {
  metadata {
    name = "kube-prometheus"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}
