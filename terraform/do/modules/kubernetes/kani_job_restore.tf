// =========================
// Kani CLI Restore Job
// =========================
// Creates a one-time Kubernetes Job to restore the database from a backup.
// This job runs the "kani db-restore" command using the kani-cli image.
resource "kubernetes_job_v1" "restore" {
  metadata {
    name      = "db-restore"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }

  spec {
    // Run once, do not retry on failure
    backoff_limit = 0

    template {
      metadata {
        labels = {
          app = "db-restore"
        }
      }

      spec {
        // Required for Kubernetes Job
        restart_policy = "Never"

        // =========================
        // Node scheduling
        // =========================
        // Ensures seed job pods are scheduled onto the primary node pool
        node_selector = {
          "doks.digitalocean.com/node-pool" = var.kubernetes_primary_node_pool_name
        }

        container {
          name  = "db-restore"
          image = "${var.kani_cli_image_repository}:${var.kani_cli_image_tag}"

          // Always pull latest image for one-off seed jobs
          image_pull_policy = "Always"

          // Execute restore command
          command = ["kani", "db", "restore", "-f", "${var.kani_db_restore_job_backup_id}"]

          // =========================
          // Environment variables
          // =========================
          // Load all non-sensitive environment variables from the shared ConfigMap
          env_from {
            config_map_ref {
              name = local.kani_cli_service_env_vars_name
            }
          }

          // Load all sensitive environment variables from the shared Secret
          env_from {
            secret_ref {
              name = local.kani_cli_service_env_vars_name
            }
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
          // Mount secret volumes for encryption keys, credentials, and configuration
          volume_mount {
            name = "gcp-cloud-kms-crypto-operator-sa"
            mount_path = var.kani_gcp_cloud_kms_crypto_operator_sa_mount_path
            read_only = true
          }
          volume_mount {
            name = "gcp-crypto-key-ed-sa"
            mount_path = var.kani_gcp_crypto_key_ed_sa_mount_path
            read_only = true
          }
          volume_mount {
            name = "gcp-google-drive-ud-sa"
            mount_path = var.kani_gcp_google_drive_ud_sa_mount_path
            read_only = true
          }
          volume_mount {
            name = "encrypted-aes-key"
            mount_path = var.kani_encrypted_aes_key_mount_path
            read_only = true
          }
          volume_mount {
            name = "encrypted-jwt-secret-key"
            mount_path = var.kani_encrypted_jwt_secret_key_mount_path
            read_only = true
          }
          volume_mount {
            name = "privy-app-secret-key"
            mount_path = var.kani_privy_app_secret_key_mount_path
            read_only = true
          }
          volume_mount {
            name = "privy-signer-private-key"
            mount_path = var.kani_privy_signer_private_key_mount_path
            read_only = true
          }
          volume_mount {
            name = "coin-market-cap-api-key"
            mount_path = var.kani_coin_market_cap_api_key_mount_path
            read_only = true
          }
          volume_mount {
            name = "rpcs"
            mount_path = var.kani_rpcs_mount_path
            read_only = true
          }
          volume_mount {
            name = "app"
            mount_path = var.kani_app_mount_path
            read_only = true
          }
          volume_mount {
            name = "data"
            mount_path = var.kani_data_mount_path
            read_only = false
          }
        }

        // =========================
        // Volumes
        // =========================
        // Define secret volumes and empty directory for Google Drive operations
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
            secret_name = local.external_secrets_instances.rpcs.target_secret_name
          }
        }
        volume {
          name = "app"
          secret {
            secret_name = local.external_secrets_instances.app.target_secret_name
          }
        }
        volume {
          name = "data"
          empty_dir {}
        }
      }
    }
  }

  // Ensure the Kani namespace and CLI Helm release exist before creating the job
  depends_on = [
    kubernetes_namespace.kani,
    helm_release.kani_cli,
    kubectl_manifest.external_secret["app"],
    kubectl_manifest.external_secret["rpcs"],
    helm_release.argo_cd,
    helm_release.grafana,
    helm_release.jenkins,
    helm_release.kafka,
    helm_release.mongodb_sharded,
    helm_release.prometheus,
    helm_release.redis_cluster,
    kubernetes_secret.gcp_cloud_kms_crypto_operator_sa,
    kubernetes_secret.gcp_crypto_key_ed_sa,
    kubernetes_secret.gcp_google_drive_ud_sa,
    kubernetes_secret.encrypted_aes_key,
    kubernetes_secret.encrypted_jwt_secret_key,
  ]
}
