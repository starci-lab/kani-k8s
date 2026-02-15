// =========================
// Redis Standalone Helm release
// =========================
// Deploys Redis Standalone using the Bitnami Helm chart (OCI).
resource "helm_release" "redis_standalone" {
  name      = local.redis_standalone.name
  namespace = kubernetes_namespace.redis_standalone.metadata[0].name

  // Bitnami Redis chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/redis"

  values = [
    templatefile("${path.module}/yamls/redis.yaml", {
      // Authentication
      password = var.redis_standalone_password
      // Master resources
      master_request_cpu    = local.redis_standalone.master.request_cpu
      master_request_memory = local.redis_standalone.master.request_memory
      master_limit_cpu      = local.redis_standalone.master.limit_cpu
      master_limit_memory   = local.redis_standalone.master.limit_memory
      // Persistence
      master_persistence_size = var.redis_standalone_master_persistence_size

      // Replica resources
      replica_replica_count = local.redis_standalone.replica.replica_count
      replica_request_cpu    = local.redis_standalone.replica.request_cpu
      replica_request_memory = local.redis_standalone.replica.request_memory
      replica_limit_cpu      = local.redis_standalone.replica.limit_cpu
      replica_limit_memory   = local.redis_standalone.replica.limit_memory
      // Persistence
      replica_persistence_size = var.redis_standalone_replica_persistence_size
      // Node scheduling
      node_pool_label = var.kubernetes_primary_node_pool_name
    })
  ]

  depends_on = [
    kubernetes_namespace.redis_standalone
  ]
}