// =========================
// Kani Interface local identifiers
// =========================
// Defines naming conventions shared across Helm, Service lookup,
// and Ingress configuration.
locals {
  // Helm release name for Kani Interface
  kani_interface_name = "kani-interface"

  // Service name exposed by the Kani Interface server component
  // (created by the Helm chart)
  kani_interface_server_service_name = "kani-interface"
}

// =========================
// Kani Interface Helm release
// =========================
// Deploys Kani Interface using the custom Helm chart.
// All configuration is injected via a Terraform-rendered values file.
resource "helm_release" "kani_interface" {
  name      = local.kani_interface_name
  namespace = kubernetes_namespace.kani.metadata[0].name
  // Custom Helm chart from chart repository
  repository = "https://k8s.kanibot.xyz/charts"
  chart = "service"
  // Render Helm values from template and inject Terraform variables
  values = [
    templatefile("${path.module}/yamls/kani-interface.yaml", {
      // =========================
      // Application configuration
      // =========================
      replica_count = var.kani_interface_replica_count
      port          = var.kani_interface_port
      // =========================
      // Cors configuration
      // =========================
      cors_origin_1 = var.kani_frontend_url_1
      cors_origin_2 = var.kani_frontend_url_2
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
      redis_cache_host     = local.redis_cluster_service.host
      redis_cache_port     = local.redis_cluster_service.port
      redis_cache_password = var.redis_password
      redis_cache_use_cluster = true
      // =========================
      // Redis Adapter configuration
      // =========================
      redis_adapter_host = local.redis_cluster_service.host
      redis_adapter_port = local.redis_cluster_service.port
      redis_adapter_password = var.redis_password
      redis_adapter_use_cluster = true
      // =========================
      // Redis BullMQ configuration
      // =========================
      redis_bullmq_host      = local.redis_cluster_service.host
      redis_bullmq_port      = local.redis_cluster_service.port
      redis_bullmq_use_cluster = true
      redis_bullmq_password = var.redis_password
      // =========================
      // Redis Throttler configuration
      // =========================
      redis_throttler_host = local.redis_cluster_service.host
      redis_throttler_port = local.redis_cluster_service.port
      redis_throttler_password = var.redis_password
      redis_throttler_use_cluster = true

      // =========================
      // Secret mount paths
      // =========================
      gcp_crypto_key_ed_sa_mount_path = var.kani_gcp_crypto_key_ed_sa_mount_path
      aes_mount_path                  = var.kani_aes_mount_path
      jwt_secret_mount_path           = var.kani_jwt_secret_mount_path
      stmp_mount_path                 = var.kani_stmp_mount_path
      api_keys_mount_path             = var.kani_api_keys_mount_path
      rpcs_mount_path                 = var.kani_rpcs_mount_path
      // =========================
      // GCP KMS configuration
      // =========================
      gcp_kms_key_name = var.kani_gcp_kms_key_name

      // =========================
      // JWT and AES configuration
      // =========================
      jwt_salt   = var.kani_jwt_salt
      aes_cbc_salt = var.kani_aes_cbc_salt

      // =========================
      // Resource configuration
      // =========================
      request_cpu    = local.kani_interface.kani_interface.request_cpu
      request_memory = local.kani_interface.kani_interface.request_memory
      limit_cpu      = local.kani_interface.kani_interface.limit_cpu
      limit_memory   = local.kani_interface.kani_interface.limit_memory

      // =========================
      // Node scheduling
      // =========================
      // Ensures Kani Interface pods are scheduled onto the primary node pool
      node_pool_label = var.kubernetes_primary_node_pool_name

      // =========================
      // Probes configuration
      // =========================
      liveness_probe_path = var.kani_liveness_probe_path
      readiness_probe_path = var.kani_readiness_probe_path
      startup_probe_path = var.kani_startup_probe_path
    })
  ]

  // Ensure the Kani namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.kani,
    kubectl_manifest.external_secret["api-keys"],
    kubectl_manifest.external_secret["rpcs"],
    kubectl_manifest.external_secret["aes"],
    kubectl_manifest.external_secret["crypto-key-ed-sa"],
    kubectl_manifest.external_secret["jwt-secret"],
    kubectl_manifest.external_secret["smtp"]
  ]
}

// -----------------------------------------------------------------------------
// Read Kani Interface server Service (for Ingress wiring)
// -----------------------------------------------------------------------------
data "kubernetes_service" "kani_interface" {
  metadata {
    name      = "kani-interface-service"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  depends_on = [helm_release.kani_interface]
}

// Pick port if present; otherwise use the first declared service port
locals {
  kani_interface_server_port = coalesce(
    try(
      [
        for p in data.kubernetes_service.kani_interface.spec[0].port :
        p.port
        if p.port == tonumber(var.kani_interface_port)
      ][0],
      null
    ),
    data.kubernetes_service.kani_interface.spec[0].port[0].port
  )
}

// -----------------------------------------------------------------------------
// Ingress (NGINX + cert-manager TLS)
// -----------------------------------------------------------------------------
resource "kubernetes_ingress_v1" "kani_interface" {
  metadata {
    name      = "kani-interface"
    namespace = kubernetes_namespace.kani.metadata[0].name

    annotations = {
      "cert-manager.io/cluster-issuer"                 = var.cert_manager_cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "acme.cert-manager.io/http01-edit-in-place"      = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = local.api_domain_name

      http {
        path {
          path = "/"

          backend {
            service {
              name = data.kubernetes_service.kani_interface.metadata[0].name
              port {
                number = local.kani_interface_server_port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.api_domain_name]
      secret_name = "kani-interface-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.api,
    helm_release.kani_interface
  ]
}
