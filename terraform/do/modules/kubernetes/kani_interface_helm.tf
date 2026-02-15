// =========================
// Kani Interface Helm release
// =========================
// Deploys Kani Interface using the custom Helm chart.
// All configuration is injected via a Terraform-rendered values file.
resource "helm_release" "kani_interface" {
  name      = local.kani_interface.name
  namespace = kubernetes_namespace.kani.metadata[0].name
  // Custom Helm chart from chart repository
  repository = "https://k8s.kanibot.xyz/charts"
  chart      = "service"
  // Render Helm values from template and inject Terraform variables
  values = [
    templatefile("${path.module}/yamls/kani-interface.yaml", {
      // Application configuration
      kani_interface_image_repository = var.kani_interface_image_repository
      kani_interface_image_tag        = var.kani_interface_image_tag
      replica_count                   = var.kani_interface_replica_count
      port                            = var.kani_interface_port
      // Cors configuration
      cors_origin_1 = var.kani_frontend_url_1
      cors_origin_2 = var.kani_frontend_url_2
      // Primary MongoDB configuration
      primary_mongodb_host     = local.mongodb_sharded_outputs.service.host
      primary_mongodb_port     = local.mongodb_sharded_outputs.service.port
      primary_mongodb_database = var.kani_primary_mongodb_database
      primary_mongodb_username = var.mongodb_root_username
      primary_mongodb_password = var.mongodb_root_password
      // Kafka configuration
      kafka_broker_host   = local.kafka_outputs.service.host
      kafka_broker_port   = local.kafka_outputs.service.port
      kafka_sasl_enabled  = var.kani_kafka_sasl_enabled
      kafka_sasl_username = var.kafka_sasl_user
      kafka_sasl_password = var.kafka_sasl_password
      // Redis Cache configuration
      redis_cache_host        = local.redis_standalone_outputs.service.host
      redis_cache_port        = local.redis_standalone_outputs.service.port
      redis_cache_password    = var.redis_standalone_password
      redis_cache_use_cluster = var.kani_redis_cache_enabled
      cache_debug_enabled     = false
      // Redis Adapter configuration
      redis_adapter_host        = local.redis_standalone_outputs.service.host
      redis_adapter_port        = local.redis_standalone_outputs.service.port
      redis_adapter_password    = var.redis_standalone_password
      redis_adapter_use_cluster = var.kani_redis_adapter_enabled
      // Redis BullMQ configuration
      redis_bullmq_host        = local.redis_standalone_outputs.service.host
      redis_bullmq_port        = local.redis_standalone_outputs.service.port
      redis_bullmq_use_cluster = var.kani_redis_bullmq_enabled
      redis_bullmq_password    = var.redis_standalone_password
      // Redis Throttler configuration
      redis_throttler_host        = local.redis_standalone_outputs.service.host
      redis_throttler_port        = local.redis_standalone_outputs.service.port
      redis_throttler_password    = var.redis_standalone_password
      redis_throttler_use_cluster = var.kani_redis_throttler_enabled
      // Secret mount paths
      gcp_cloud_kms_crypto_operator_sa_mount_path = var.kani_gcp_cloud_kms_crypto_operator_sa_mount_path
      gcp_crypto_key_ed_sa_mount_path = var.kani_gcp_crypto_key_ed_sa_mount_path
      gcp_google_drive_ud_sa_mount_path = var.kani_gcp_google_drive_ud_sa_mount_path
      encrypted_aes_key_mount_path                    = var.kani_encrypted_aes_key_mount_path
      encrypted_jwt_secret_key_mount_path             = var.kani_encrypted_jwt_secret_key_mount_path
      privy_app_secret_key_mount_path                 = var.kani_privy_app_secret_key_mount_path
      privy_signer_private_key_mount_path             = var.kani_privy_signer_private_key_mount_path
      coin_market_cap_api_key_mount_path              = var.kani_coin_market_cap_api_key_mount_path
      // Configuration secrets
      rpcs_mount_path                   = var.kani_rpcs_mount_path
      app_mount_path                        = var.kani_app_mount_path
      // JWT and AES configuration
      jwt_salt     = var.kani_jwt_salt
      aes_cbc_salt = var.kani_aes_cbc_salt
      // Resource configuration
      request_cpu    = local.kani_interface.kani_interface.request_cpu
      request_memory = local.kani_interface.kani_interface.request_memory
      limit_cpu      = local.kani_interface.kani_interface.limit_cpu
      limit_memory   = local.kani_interface.kani_interface.limit_memory
      // Node scheduling
      node_pool_label = var.kubernetes_primary_node_pool_name
      // Probes configuration
      liveness_probe_path  = var.kani_liveness_probe_path
      readiness_probe_path = var.kani_readiness_probe_path
      startup_probe_path   = var.kani_startup_probe_path
      // Consul
      consul_host = "http://${local.consul_outputs.headless_service.host}:${local.consul_outputs.headless_service.port}"
      // Loki
      loki_host = "http://${local.loki_monolithic_outputs.gateway_service.host}:${local.loki_monolithic_outputs.gateway_service.port}"
      // Secret names
      gcp_cloud_kms_crypto_operator_sa_secret_name = kubernetes_secret.gcp_cloud_kms_crypto_operator_sa.metadata[0].name
      gcp_crypto_key_ed_sa_secret_name = kubernetes_secret.gcp_crypto_key_ed_sa.metadata[0].name
      gcp_google_drive_ud_sa_secret_name = kubernetes_secret.gcp_google_drive_ud_sa.metadata[0].name
      encrypted_aes_key_secret_name = kubernetes_secret.encrypted_aes_key.metadata[0].name
      encrypted_jwt_secret_key_secret_name = kubernetes_secret.encrypted_jwt_secret_key.metadata[0].name
      app_secret_name = local.external_secrets.instances.app.target_secret_name
      rpcs_secret_name = local.external_secrets.instances.rpcs.target_secret_name
      privy_app_secret_key_secret_name = kubernetes_secret.privy_app_secret_key.metadata[0].name
      privy_signer_private_key_secret_name = kubernetes_secret.privy_signer_private_key.metadata[0].name
      coin_market_cap_api_key_secret_name = kubernetes_secret.coin_market_cap_api_key.metadata[0].name
    })
  ]

  // Ensure the Kani namespace exists before installing the chart
  depends_on = [
    # Kubernetes namespace
    kubernetes_namespace.kani,
    # External Secrets
    kubectl_manifest.external_secret["app"],
    kubectl_manifest.external_secret["rpcs"],
    # Kubernetes secrets
    kubernetes_secret.gcp_cloud_kms_crypto_operator_sa,
    kubernetes_secret.gcp_crypto_key_ed_sa,
    kubernetes_secret.gcp_google_drive_ud_sa,
    kubernetes_secret.encrypted_aes_key,
    kubernetes_secret.encrypted_jwt_secret_key,
    # Kubernetes jobs
    # kubernetes_job_v1.restore,
    kubernetes_job_v1.seed,
    # helm_release.argo_cd, # Commented out - argo_cd helm release is currently disabled
    helm_release.grafana,
    # helm_release.jenkins,
    helm_release.kafka,
    helm_release.mongodb_sharded,
    helm_release.kube_prometheus,
    helm_release.redis_standalone,
    helm_release.consul,
    helm_release.loki_monolithic,
  ]
}
