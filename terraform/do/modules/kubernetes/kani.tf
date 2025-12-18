// =========================
// Namespace for Kani
// =========================
// Creates a dedicated namespace for Kani resources.
resource "kubernetes_namespace" "kani" {
  metadata {
    name = "kani"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}
