// =========================
// Kani CLI pod
// =========================
// Standalone pod for Kani CLI operations (manual load/seed).
// Uses env from the shared ConfigMap/Secret created by the Kani CLI Helm release.
resource "kubernetes_pod_v1" "cli" {
  // =========================
  // Metadata
  // =========================
  metadata {
    name      = "kani-cli"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  // =========================
  // Pod spec
  // =========================
  spec {
    node_selector = {
      "doks.digitalocean.com/node-pool" = var.kubernetes_primary_node_pool_name
    }
    // =========================
    // Container configuration
    // =========================
    container {
      name  = "cli"
      image = "${var.kani_cli_image_repository}:${var.kani_cli_image_tag}"

      image_pull_policy = "Always"

      // Load all non-sensitive environment variables from the shared ConfigMap
      env_from {
        config_map_ref {
          name = local.kani_cli.service_env_vars_name
        }
      }

      // Load all sensitive environment variables from the shared Secret
      env_from {
        secret_ref {
          name = local.kani_cli.service_env_vars_name
        }
      }

      // Enable manual load and disable manual seed, with mean no automatic load and seed will be performed.
      env {
        name  = "PRIMARY_MONGO_DB_MANUAL_LOAD"
        value = "true"
      }

      env {
        name  = "PRIMARY_MONGO_DB_MANUAL_SEED"
        value = "false"
      }

      // =========================
      // Resource configuration
      // =========================
      // Resource constraints for predictable scheduling
      resources {
        requests = {
          cpu    = local.kani_cli.kani_cli.request_cpu
          memory = local.kani_cli.kani_cli.request_memory
        }

        limits = {
          cpu    = local.kani_cli.kani_cli.limit_cpu
          memory = local.kani_cli.kani_cli.limit_memory
        }
      }

      // =========================
      // Volume mounts
      // =========================
      // =========================
      volume_mount {
        name       = "gcp-cloud-kms-crypto-operator-sa"
        mount_path = var.kani_gcp_cloud_kms_crypto_operator_sa_mount_path
        read_only  = true
      }
      volume_mount {
        name       = "gcp-crypto-key-ed-sa"
        mount_path = var.kani_gcp_crypto_key_ed_sa_mount_path
        read_only  = true
      }
      volume_mount {
        name       = "gcp-google-drive-ud-sa"
        mount_path = var.kani_gcp_google_drive_ud_sa_mount_path
        read_only  = true
      }
      volume_mount {
        name       = "encrypted-aes-key"
        mount_path = var.kani_encrypted_aes_key_mount_path
        read_only  = true
      }
      volume_mount {
        name       = "encrypted-jwt-secret-key"
        mount_path = var.kani_encrypted_jwt_secret_key_mount_path
        read_only  = true
      }
      volume_mount {
        name       = "privy-app-secret-key"
        mount_path = var.kani_privy_app_secret_key_mount_path
        read_only  = true
      }
      volume_mount {
        name       = "privy-signer-private-key"
        mount_path = var.kani_privy_signer_private_key_mount_path
        read_only  = true
      }
      volume_mount {
        name       = "coin-market-cap-api-key"
        mount_path = var.kani_coin_market_cap_api_key_mount_path
        read_only  = true
      }
      volume_mount {
        name       = "rpcs"
        mount_path = var.kani_rpcs_mount_path
        read_only  = true
      }
      volume_mount {
        name       = "app"
        mount_path = var.kani_app_mount_path
        read_only  = true
      }
      volume_mount {
        name       = "data"
        mount_path = "/data"
        read_only  = false
      }
    }

    // =========================
    // Volumes
    // =========================
    volume {
      name = "gcp-cloud-kms-crypto-operator-sa"
      secret {
        secret_name = kubernetes_secret.gcp_cloud_kms_crypto_operator_sa.metadata[0].name
      }
    }
    volume {
      name = "gcp-crypto-key-ed-sa"
      secret {
        secret_name = kubernetes_secret.gcp_crypto_key_ed_sa.metadata[0].name
      }
    }
    volume {
      name = "gcp-google-drive-ud-sa"
      secret {
        secret_name = kubernetes_secret.gcp_google_drive_ud_sa.metadata[0].name
      }
    }
    volume {
      name = "encrypted-aes-key"
      secret {
        secret_name = kubernetes_secret.encrypted_aes_key.metadata[0].name
      }
    }
    volume {
      name = "encrypted-jwt-secret-key"
      secret {
        secret_name = kubernetes_secret.encrypted_jwt_secret_key.metadata[0].name
      }
    }
    volume {
      name = "privy-app-secret-key"
      secret {
        secret_name = kubernetes_secret.privy_app_secret_key.metadata[0].name
      }
    }
    volume {
      name = "privy-signer-private-key"
      secret {
        secret_name = kubernetes_secret.privy_signer_private_key.metadata[0].name
      }
    }
    volume {
      name = "coin-market-cap-api-key"
      secret {
        secret_name = kubernetes_secret.coin_market_cap_api_key.metadata[0].name
      }
    }
    volume {
      name = "rpcs"
      secret {
        secret_name = local.external_secrets.instances.rpcs.target_secret_name
      }
    }
    volume {
      name = "app"
      secret {
        secret_name = local.external_secrets.instances.app.target_secret_name
      }
    }
    volume {
      name = "data"
      empty_dir {}
    }
  }
  // =========================
  // Dependencies
  // =========================
  depends_on = [
    kubernetes_namespace.kani,
    helm_release.kani_cli,
  ]
}
