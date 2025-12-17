# Namespace for Redis Cluster
resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka"
  }
  depends_on = [ digitalocean_kubernetes_cluster.kubernetes ]
}

# MongoDB Sharded
resource "helm_release" "kafka" {
  name             = "kafka"
  namespace        = kubernetes_namespace.kafka.metadata[0].name
  chart = "oci://registry-1.docker.io/bitnamicharts/kafka"
  values = [
    templatefile(
      "${path.module}/yamls/kafka.yaml", {
          # Authentication
          sasl_user = var.kafka_sasl_user
          sasl_password = var.kafka_sasl_password
          limit_cpu = var.kafka_limit_cpu
          limit_memory = var.kafka_limit_memory
          # Controller
          controller_request_cpu = var.kafka_controller_request_cpu
          controller_request_memory = var.kafka_controller_request_memory
          controller_limit_cpu = var.kafka_controller_limit_cpu
          controller_limit_memory = var.kafka_controller_limit_memory
          controller_persistence_size = var.kafka_controller_persistence_size
          controller_log_persistence_size = var.kafka_controller_log_persistence_size
          # Broker
          broker_request_cpu = var.kafka_broker_request_cpu
          broker_request_memory = var.kafka_broker_request_memory
          broker_limit_cpu = var.kafka_broker_limit_cpu
          broker_limit_memory = var.kafka_broker_limit_memory
          # Node pool label
          node_pool_label = var.kubernetes_node_pool_name
          
          volume_permissions_request_cpu = var.volume_permissions_request_cpu
          volume_permissions_request_memory = var.volume_permissions_request_memory
          volume_permissions_limit_cpu = var.volume_permissions_limit_cpu
          volume_permissions_limit_memory = var.volume_permissions_limit_memory
    })
  ]
  depends_on = [
    kubernetes_namespace.mongodb_sharded
  ]
}