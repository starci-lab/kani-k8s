# MongoDB Sharded
resource "helm_release" "mongodb_sharded" {
  name             = "mongodb-sharded"
  namespace        = kubernetes_namespace.databases.metadata[0].name
  create_namespace = true
  chart = "oci://registry-1.docker.io/bitnamicharts/mongodb-sharded"
  values = [
    templatefile(
      "${path.module}/yamls/mongodb-sharded.yaml", {
          username = var.mongodb_root_username
          password = var.mongodb_root_password
          # Config Server
          configsvr_replica_count = var.mongodb_configsvr_replica_count
          configsvr_persistence_size = var.mongodb_configsvr_persistence_size
          configsvr_request_cpu = var.mongodb_configsvr_request_cpu
          configsvr_request_memory = var.mongodb_configsvr_request_memory
          configsvr_limit_cpu = var.mongodb_configsvr_limit_cpu
          configsvr_limit_memory = var.mongodb_configsvr_limit_memory
          # Shard Server
          shardsvr_replica_count = var.mongodb_shardsvr_replica_count
          shardsvr_persistence_size = var.mongodb_shardsvr_persistence_size
          shardsvr_request_cpu = var.mongodb_shardsvr_request_cpu
          shardsvr_request_memory = var.mongodb_shardsvr_request_memory
          shardsvr_limit_cpu = var.mongodb_shardsvr_limit_cpu
          shardsvr_limit_memory = var.mongodb_shardsvr_limit_memory
          # Mongos Router
          mongos_replica_count = var.mongodb_mongos_replica_count
          mongos_request_cpu = var.mongodb_request_cpu
          mongos_request_memory = var.mongodb_request_memory
          mongos_limit_cpu = var.mongodb_limit_cpu
          mongos_limit_memory = var.mongodb_limit_memory
          node_pool_label = var.workload_node_pool_label
    })
  ]
  depends_on = [
    kubernetes_namespace.databases
  ]
}