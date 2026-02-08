// =========================
// Kafka Helm release
// =========================
// Deploys Apache Kafka using the Bitnami Helm chart.
// Configuration is provided via a templated values file,
// including authentication, resource allocation, persistence,
// and node scheduling.
resource "helm_release" "kafka" {
  name      = "kafka"
  namespace = kubernetes_namespace.kafka.metadata[0].name

  // Bitnami Kafka chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/kafka"

  // Render Helm values from a Terraform template and inject variables
  values = [
    templatefile("${path.module}/yamls/kafka.yaml", {
      // Authentication (SASL)
      sasl_user     = var.kafka_sasl_user
      sasl_password = var.kafka_sasl_password
      // Kafka controller resources & persistence
      controller_request_cpu          = local.kafka.controller.request_cpu
      controller_request_memory       = local.kafka.controller.request_memory
      controller_limit_cpu            = local.kafka.controller.limit_cpu
      controller_limit_memory         = local.kafka.controller.limit_memory
      controller_persistence_size     = var.kafka_controller_persistence_size
      controller_log_persistence_size = var.kafka_controller_log_persistence_size
      controller_replica_count        = 1
      controller_only                 = var.kafka_controller_only
      // Kafka broker (replica count + resources)
      broker_replica_count  = var.kafka_broker_replica_count
      broker_request_cpu    = local.kafka.broker.request_cpu
      broker_request_memory = local.kafka.broker.request_memory
      broker_limit_cpu      = local.kafka.broker.limit_cpu
      broker_limit_memory   = local.kafka.broker.limit_memory
      broker_persistence_size = var.kafka_broker_persistence_size
      // Node scheduling
      node_pool_label = var.kubernetes_primary_node_pool_name
      // Volume permissions init container
      volume_permissions_request_cpu    = local.kafka.volume_permissions.request_cpu
      volume_permissions_request_memory = local.kafka.volume_permissions.request_memory
      volume_permissions_limit_cpu      = local.kafka.volume_permissions.limit_cpu
      volume_permissions_limit_memory   = local.kafka.volume_permissions.limit_memory
    })
  ]

  // Ensure the Kafka namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.kafka
  ]
}
