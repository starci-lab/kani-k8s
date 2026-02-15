// =========================
// Namespace for Redis Standalone
// =========================
// Creates a dedicated namespace for Redis Standalone resources.
resource "kubernetes_namespace" "redis_standalone" {
  metadata {
    name = "redis-standalone"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// Redis Standalone Service (data)
// =========================
// Fetches the Service created by the Redis Standalone Helm chart.
data "kubernetes_service" "redis_standalone" {
  metadata {
    name      = local.redis_standalone.services.service.name
    namespace = kubernetes_namespace.redis_standalone.metadata[0].name
  }
  depends_on = [helm_release.redis_standalone]
}
