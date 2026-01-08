// =========================
// Kani CLI Job Seed local identifiers
// =========================
// Defines shared names for ConfigMap and Secret created by kani-cli Helm chart.
locals {
  // Shared name for ConfigMap & Secret created by kani-cli Helm chart
  // Contains all runtime environment variables (DB, Kafka, etc.)
  kani_cli_service_env_vars_name = "kani-cli-service-env-vars"
}

// =========================
// Kani CLI Secret data source
// =========================
// Reads the Secret containing sensitive environment variables
// created by the kani-cli Helm chart.
data "kubernetes_secret" "cli" {
  metadata {
    name      = local.kani_cli_service_env_vars_name
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  // Ensure Helm release is created before reading the Secret
  depends_on = [
    helm_release.kani_cli
  ]
}

// =========================
// Kani CLI ConfigMap data source
// =========================
// Reads the ConfigMap containing non-sensitive environment variables
// created by the kani-cli Helm chart.
data "kubernetes_config_map" "cli" {
  metadata {
    name      = local.kani_cli_service_env_vars_name
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  // Ensure Helm release is created before reading the ConfigMap
  depends_on = [
    helm_release.kani_cli
  ]
}

// =========================
// Kani CLI Seed Job
// =========================
// Creates a one-time Kubernetes Job to seed the database with initial data.
// This job runs the "kani seed" command using the kani-cli image.
resource "kubernetes_job_v1" "seed" {
  metadata {
    name      = "seed"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  spec {
    // Run once, do not retry on failure
    backoff_limit = 0

    template {
      metadata {
        labels = {
          app = "seed"
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
          name  = "seed"
          image = "${var.kani_cli_image_repository}:${var.kani_cli_image_tag}"

          // Always pull latest image for one-off seed jobs
          image_pull_policy = "Always"

          // Execute seed command
          command = ["kani", "seed"]

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
            name = "encrypted-aes"
            mount_path = var.kani_encrypted_aes_mount_path
            read_only = true
          }
          volume_mount {
            name = "encrypted-jwt-secret"
            mount_path = var.kani_encrypted_jwt_secret_mount_path
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
        }

        // =========================
        // Volumes
        // =========================
        // Define secret volumes and empty directory for Google Drive operations
        volume {
          name = "gcp-cloud-kms-crypto-operator-sa"
          secret {
            secret_name = "gcp-cloud-kms-crypto-operator-sa"
          }
        }
        volume {
          name = "gcp-crypto-key-ed-sa"
          secret {
            secret_name = "gcp-crypto-key-ed-sa"
          }
        }
        volume {
          name = "gcp-google-drive-ud-sa"
          secret {
            secret_name = "gcp-google-drive-ud-sa"
          }
        }
        volume {
          name = "encrypted-aes"
          secret {
            secret_name = "encrypted-aes"
          }
        }
        volume {
          name = "encrypted-jwt-secret"
          secret {
            secret_name = "encrypted-jwt-secret"
          }
        }
        volume {
          name = "rpcs"
          secret {
            secret_name = "rpcs"
          }
        }
        volume {
          name = "app"
          secret {
            secret_name = "app"
          }
        }
        volume {
          name = "dir-google-drive"
          empty_dir {}
        }
      }
    }
  }

  // Ensure the Kani namespace and CLI Helm release exist before creating the job
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
