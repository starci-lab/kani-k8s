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
// Redis Cluster Helm release
// =========================
// Deploys Redis Cluster using the Bitnami Helm chart.
// This release is conditionally deployed via enable_redis_cluster.
resource "helm_release" "redis_cluster" {
  name      = "redis-cluster"
  namespace = kubernetes_namespace.redis_cluster.metadata[0].name

  // Bitnami Redis Cluster chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/redis-cluster"

  values = [
    templatefile("${path.module}/yamls/redis-cluster.yaml", {
      // =========================
      // Authentication
      // =========================
      password = var.redis_password
      // =========================
      // Cluster topology
      // =========================
      nodes    = var.redis_nodes
      replicas = var.redis_replicas
      // =========================
      // Resources per node
      // =========================
      request_cpu    = var.redis_request_cpu
      request_memory = var.redis_request_memory
      limit_cpu      = var.redis_limit_cpu
      limit_memory   = var.redis_limit_memory
      // =========================
      // Persistence
      // =========================
      persistence_size = var.redis_persistence_size
      // =========================
      // Node scheduling
      // =========================
      node_pool_label = var.kubernetes_primary_node_pool_name
    })
  ]

  depends_on = [
    kubernetes_namespace.redis_cluster
  ]
}