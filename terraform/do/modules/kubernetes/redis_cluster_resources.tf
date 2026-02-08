// =========================
// Namespace for Redis Cluster
// =========================
// Creates a dedicated namespace for Redis Cluster resources.
resource "kubernetes_namespace" "redis_cluster" {
  metadata {
    name = "redis-cluster"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// Redis Cluster Service (data)
// =========================
// Fetches the Service created by the Redis Cluster Helm chart.
data "kubernetes_service" "redis_cluster" {
  metadata {
    name      = local.redis_cluster.name
    namespace = kubernetes_namespace.redis_cluster.metadata[0].name
  }
}
