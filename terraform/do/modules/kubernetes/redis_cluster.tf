# Namespace for Redis Cluster
resource "kubernetes_namespace" "redis_cluster" {
  metadata {
    name = "redis-cluster"
  }
  depends_on = [ digitalocean_kubernetes_cluster.kubernetes ]
}

# MongoDB Sharded
resource "helm_release" "redis_cluster" {
  name             = "redis-cluster"
  namespace        = kubernetes_namespace.redis_cluster.metadata[0].name
  chart = "oci://registry-1.docker.io/bitnamicharts/redis-cluster"
  values = [
    templatefile(
      "${path.module}/yamls/redis-cluster.yaml", {
          # Authentication
          password = var.redis_password
          # Nodes
          nodes = var.redis_nodes
          # Replicas
          replicas = var.redis_replicas
          # Request CPU
          request_cpu = var.redis_request_cpu
          request_memory = var.redis_request_memory
          limit_cpu = var.redis_limit_cpu
          limit_memory = var.redis_limit_memory
          # Persistence size
          persistence_size = var.redis_persistence_size
          # Node pool label
          node_pool_label = var.kubernetes_node_pool_name
    })
  ]
  depends_on = [
    kubernetes_namespace.mongodb_sharded
  ]
}