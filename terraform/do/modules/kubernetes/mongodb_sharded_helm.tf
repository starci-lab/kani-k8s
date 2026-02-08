// =========================
// MongoDB Sharded Helm release
// =========================
// Deploys a MongoDB sharded cluster using the Bitnami Helm chart.
// Configuration is provided via a Terraform-rendered values file,
// including authentication, sharding topology, resource allocation,
// persistence, and node scheduling.
resource "helm_release" "mongodb_sharded" {
  name             = "mongodb-sharded"
  namespace        = kubernetes_namespace.mongodb_sharded.metadata[0].name
  create_namespace = true

  // Bitnami MongoDB Sharded chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/mongodb-sharded"

  // Render Helm values from a Terraform template and inject variables
  values = [
    templatefile("${path.module}/yamls/mongodb-sharded.yaml", {
      // Authentication
      username = var.mongodb_root_username
      password = var.mongodb_root_password
      replica_set_key = var.mongodb_replica_set_key
      // Sharding configuration
      shards = var.mongodb_shards
      // Config Server configuration
      configsvr_replica_count      = var.mongodb_configsvr_replica_count
      configsvr_persistence_size   = var.mongodb_configsvr_persistence_size
      configsvr_request_cpu        = local.mongodb.configsvr.request_cpu
      configsvr_request_memory     = local.mongodb.configsvr.request_memory
      configsvr_limit_cpu          = local.mongodb.configsvr.limit_cpu
      configsvr_limit_memory       = local.mongodb.configsvr.limit_memory
      // Shard Server configuration
      shardsvr_replica_count       = var.mongodb_shardsvr_replica_count
      shardsvr_persistence_size    = var.mongodb_shardsvr_persistence_size
      shardsvr_request_cpu         = local.mongodb.shardsvr.request_cpu
      shardsvr_request_memory      = local.mongodb.shardsvr.request_memory
      shardsvr_limit_cpu           = local.mongodb.shardsvr.limit_cpu
      shardsvr_limit_memory        = local.mongodb.shardsvr.limit_memory
      // Mongos Router configuration
      mongos_replica_count         = var.mongodb_mongos_replica_count
      mongos_request_cpu           = local.mongodb.mongos.request_cpu
      mongos_request_memory        = local.mongodb.mongos.request_memory
      mongos_limit_cpu             = local.mongodb.mongos.limit_cpu
      mongos_limit_memory          = local.mongodb.mongos.limit_memory
      // Node scheduling
      node_pool_label = var.kubernetes_primary_node_pool_name
    })
  ]

  // Ensure the MongoDB namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.mongodb_sharded
  ]
}
