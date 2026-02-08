// =========================
// Namespace for Kafka
// =========================
// Creates a dedicated namespace for Kafka resources.
resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// Kafka Service (data)
// =========================
// Used to build the Kafka bootstrap address for UI and clients.
data "kubernetes_service" "kafka" {
  metadata {
    name      = "kafka"
    namespace = kubernetes_namespace.kafka.metadata[0].name
  }
}
