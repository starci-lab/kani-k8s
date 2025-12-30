// =========================
// Kani CLI Google APIs Backup CronJob
// =========================
// Creates a scheduled Kubernetes CronJob to backup Google APIs data.
// This cron job runs hourly and executes the "kani googleapis backup" command.
resource "kubernetes_cron_job_v1" "googleapis_backup" {
  metadata {
    name      = "googleapis-backup"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  spec {
    // Run every hour at minute 0
    schedule = "0 * * * *"

    job_template {
      metadata {
        labels = {
          app = "googleapis-backup"
        }
      }

      spec {
        // Do not retry failed jobs
        backoff_limit = 0

        template {
          metadata {
            labels = {
              app = "googleapis-backup"
            }
          }

          spec {
            // Required for Job pods
            restart_policy = "Never"

            // =========================
            // Node scheduling
            // =========================
            // Ensures backup job pods are scheduled onto the primary node pool
            node_selector = {
              "doks.digitalocean.com/node-pool" = var.kubernetes_primary_node_pool_name
            }

            container {
              name  = "googleapis-backup"
              image = "${var.kani_cli_image_repository}:${var.kani_cli_image_tag}"

              // Always pull latest image for backup jobs
              image_pull_policy = "Always"
              // Execute Google APIs backup command
              command = ["kani", "googleapis", "backup"]

              // =========================
              // Environment variables
              // =========================
              // Load non-sensitive environment variables from the shared ConfigMap
              env_from {
                config_map_ref {
                  name = local.kani_cli_service_env_vars_name
                }
              }

              // Load sensitive environment variables from the shared Secret
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
                name       = "aes"
                mount_path = var.kani_aes_mount_path
                read_only  = true
              }

              volume_mount {
                name       = "crypto-key-ed-sa"
                mount_path = var.kani_gcp_crypto_key_ed_sa_mount_path
                read_only  = true
              }

              volume_mount {
                name       = "jwt-secret"
                mount_path = var.kani_jwt_secret_mount_path
                read_only  = true
              }

              volume_mount {
                name       = "smtp"
                mount_path = var.kani_stmp_mount_path
                read_only  = true
              }

              volume_mount {
                name       = "api-keys"
                mount_path = var.kani_api_keys_mount_path
                read_only  = true
              }

              volume_mount {
                name       = "rpcs"
                mount_path = var.kani_rpcs_mount_path
                read_only  = true
              }

              volume_mount {
                name       = "google-drive-ud-sa"
                mount_path = var.kani_google_drive_ud_sa_mount_path
                read_only  = true
              }

              volume_mount {
                name       = "dir-google-drive"
                mount_path = var.kani_google_drive_mount_path
              }
            }

            // =========================
            // Volumes
            // =========================
            // Define secret volumes and empty directory for Google Drive operations
            volume {
              name = "aes"
              secret {
                secret_name = "aes"
              }
            }

            volume {
              name = "crypto-key-ed-sa"
              secret {
                secret_name = "crypto-key-ed-sa"
              }
            }

            volume {
              name = "jwt-secret"
              secret {
                secret_name = "jwt-secret"
              }
            }

            volume {
              name = "smtp"
              secret {
                secret_name = "smtp"
              }
            }

            volume {
              name = "api-keys"
              secret {
                secret_name = "api-keys"
              }
            }

            volume {
              name = "rpcs"
              secret {
                secret_name = "rpcs"
              }
            }

            volume {
              name = "google-drive-ud-sa"
              secret {
                secret_name = "google-drive-ud-sa"
              }
            }

            volume {
              name      = "dir-google-drive"
              empty_dir {}
            }
          }
        }
      }
    }
  }

  // Ensure the Kani namespace and CLI Helm release exist before creating the cron job
  depends_on = [
    kubernetes_namespace.kani,
    helm_release.kani_cli
  ]
}
