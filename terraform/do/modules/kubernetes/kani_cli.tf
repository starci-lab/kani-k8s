// =========================
// Kani CLI local identifiers
// =========================
// Defines naming conventions shared across Helm, Service lookup,
// and Ingress configuration.
locals {
  // Helm release name for Kani CLI
  kani_cli_name = "kani-cli"

  // Service name exposed by the Kani CLI server component
  // (created by the Helm chart)
  kani_cli_server_service_name = "kani-cli"
}

// =========================
// Kani CLI Helm release
// =========================
// Deploys Kani CLI using the custom Helm chart.
// All configuration is injected via a Terraform-rendered values file.
resource "helm_release" "kani_cli" {
  name      = local.kani_cli_name
  namespace = kubernetes_namespace.kani.metadata[0].name
  // Custom Helm chart from chart repository
  repository = "https://k8s.kanibot.xyz/charts"
  chart      = "service"
  // Render Helm values from template and inject Terraform variables
  values = [
    templatefile("${path.module}/yamls/kani-cli.yaml", {
      // =========================
      // Application configuration
      // =========================
      kani_cli_image_repository = var.kani_cli_image_repository
      kani_cli_image_tag        = var.kani_cli_image_tag
      replica_count             = var.kani_cli_replica_count
      port                      = var.kani_cli_port
      // =========================
      // Primary MongoDB configuration
      // =========================
      primary_mongodb_host     = local.mongodb_sharded_service.host
      primary_mongodb_port     = local.mongodb_sharded_service.port
      primary_mongodb_database = var.kani_primary_mongodb_database
      primary_mongodb_username = var.mongodb_root_username
      primary_mongodb_password = var.mongodb_root_password
      // =========================
      // Kafka configuration
      // =========================
      kafka_broker_host   = local.kafka_service.host
      kafka_broker_port   = local.kafka_service.port
      kafka_sasl_enabled  = var.kani_kafka_sasl_enabled
      kafka_sasl_username = var.kafka_sasl_user
      kafka_sasl_password = var.kafka_sasl_password
      // =========================
      // Redis Cache configuration
      // =========================
      redis_cache_host        = local.redis_cluster_service.host
      redis_cache_port        = local.redis_cluster_service.port
      redis_cache_password    = var.redis_password
      redis_cache_use_cluster = true
      // =========================
      // Redis Adapter configuration
      // =========================
      redis_adapter_host        = local.redis_cluster_service.host
      redis_adapter_port        = local.redis_cluster_service.port
      redis_adapter_password    = var.redis_password
      redis_adapter_use_cluster = true
      // =========================
      // Redis BullMQ configuration
      // =========================
      redis_bullmq_host        = local.redis_cluster_service.host
      redis_bullmq_port        = local.redis_cluster_service.port
      redis_bullmq_use_cluster = true
      redis_bullmq_password    = var.redis_password
      // =========================
      // Redis Throttler configuration
      // =========================
      redis_throttler_host        = local.redis_cluster_service.host
      redis_throttler_port        = local.redis_cluster_service.port
      redis_throttler_password    = var.redis_password
      redis_throttler_use_cluster = true
      // =========================
      // Secret mount paths
      // =========================
      // Terraform variables
      gcp_cloud_kms_crypto_operator_sa_mount_path = var.kani_gcp_cloud_kms_crypto_operator_sa_mount_path
      gcp_crypto_key_ed_sa_mount_path = var.kani_gcp_crypto_key_ed_sa_mount_path
      gcp_google_drive_ud_sa_mount_path = var.kani_gcp_google_drive_ud_sa_mount_path
      encrypted_aes_mount_path                    = var.kani_encrypted_aes_mount_path
      encrypted_jwt_secret_mount_path             = var.kani_encrypted_jwt_secret_mount_path
      // Configuration secrets
      rpcs_mount_path                   = var.kani_rpcs_mount_path
      app_mount_path                        = var.kani_app_mount_path
      // =========================
      // JWT and AES configuration
      // =========================
      jwt_salt     = var.kani_jwt_salt
      aes_cbc_salt = var.kani_aes_cbc_salt
      // =========================
      // Resource configuration
      // =========================
      request_cpu    = local.kani_cli.kani_cli.request_cpu
      request_memory = local.kani_cli.kani_cli.request_memory
      limit_cpu      = local.kani_cli.kani_cli.limit_cpu
      limit_memory   = local.kani_cli.kani_cli.limit_memory
      // =========================
      // Node scheduling
      // =========================
      // Ensures Kani CLI pods are scheduled onto the primary node pool
      node_pool_label = var.kubernetes_primary_node_pool_name
      // =========================
      // Probes configuration
      // =========================
      liveness_probe_path  = var.kani_liveness_probe_path
      readiness_probe_path = var.kani_readiness_probe_path
      startup_probe_path   = var.kani_startup_probe_path
    })
  ]

  // Ensure the Kani namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.kani,
    kubectl_manifest.external_secret["app"],
    kubectl_manifest.external_secret["rpcs"],
    helm_release.argo_cd,
    helm_release.grafana,
    helm_release.jenkins,
    helm_release.kafka,
    helm_release.mongodb_sharded,
    helm_release.prometheus,
    helm_release.redis_cluster,
    kubernetes_secret.gcp_cloud_kms_crypto_operator,
    kubernetes_secret.gcp_crypto_key_ed,
    kubernetes_secret.gcp_google_drive_ud,
    kubernetes_secret.encrypted_aes,
    kubernetes_secret.encrypted_jwt_secret,
  ]
}
