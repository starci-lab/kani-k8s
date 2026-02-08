// =========================
// Redis Cluster Helm release
// =========================
// Deploys Redis Cluster using the Bitnami Helm chart.
// This release is conditionally deployed via enable_redis_cluster.
resource "helm_release" "redis_cluster" {
  name      = local.redis.name
  namespace = kubernetes_namespace.redis_cluster.metadata[0].name

  // Bitnami Redis Cluster chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/redis-cluster"

  values = [
    templatefile("${path.module}/yamls/redis-cluster.yaml", {
      // Authentication
      password = var.redis_password
      // Cluster topology
      nodes    = var.redis_nodes
      replicas = var.redis_replicas
      // Resources per node
      request_cpu    = local.redis.redis.request_cpu
      request_memory = local.redis.redis.request_memory
      limit_cpu      = local.redis.redis.limit_cpu
      limit_memory   = local.redis.redis.limit_memory
      // Persistence
      persistence_size = var.redis_persistence_size
      // Node scheduling
      node_pool_label = var.kubernetes_primary_node_pool_name
    })
  ]

  depends_on = [
    kubernetes_namespace.redis_cluster
  ]
}
