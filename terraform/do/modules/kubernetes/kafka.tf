// =========================
// Namespace for Kafka
// =========================
// Creates a dedicated namespace for Kafka resources.
resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

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

      // =========================
      // Authentication (SASL)
      // =========================
      sasl_user     = var.kafka_sasl_user
      sasl_password = var.kafka_sasl_password

      // =========================
      // Kafka controller resources & persistence
      // =========================
      controller_request_cpu          = local.kafka.controller.request_cpu
      controller_request_memory       = local.kafka.controller.request_memory
      controller_limit_cpu            = local.kafka.controller.limit_cpu
      controller_limit_memory         = local.kafka.controller.limit_memory
      controller_persistence_size     = var.kafka_controller_persistence_size
      controller_log_persistence_size = var.kafka_controller_log_persistence_size
      controller_replica_count        = 1

      // =========================
      // Kafka broker resources
      // =========================
      broker_request_cpu    = local.kafka.broker.request_cpu
      broker_request_memory = local.kafka.broker.request_memory
      broker_limit_cpu      = local.kafka.broker.limit_cpu
      broker_limit_memory   = local.kafka.broker.limit_memory

      // =========================
      // Node scheduling
      // =========================
      // Used to schedule Kafka pods onto a specific node pool
      node_pool_label = var.kubernetes_primary_node_pool_name

      // =========================
      // Volume permissions init container
      // =========================
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

// =========================
// Kafka Service
// =========================
// Retrieves the Kafka service name.
data "kubernetes_service" "kafka" {
  metadata {
    name = "kafka"
    namespace = kubernetes_namespace.kafka.metadata[0].name
  }
}

// =========================
// Kafka Host
// =========================
// Constructs the Kafka host name.
locals {
  kafka_service = {
    host = "${data.kubernetes_service.kafka.metadata[0].name}.${kubernetes_namespace.kafka.metadata[0].name}.svc.cluster.local"
    port = 9092
  }
  kafka_ui_service = {
    host = "kafka-ui.${kubernetes_namespace.kafka.metadata[0].name}.svc.cluster.local"
    port = 8080
  }
}

# Kafka UI Deployment
#
# This deployment runs Kafka UI (Provectus),
# a web-based tool for monitoring and managing
# Kafka clusters (topics, consumers, brokers, etc.)
#
# Kafka cluster itself is deployed separately via Helm
resource "kubernetes_deployment" "kafka_ui" {

  # Metadata: name, namespace, labels
  metadata {
    name      = "kafka-ui"
    namespace = kubernetes_namespace.kafka.metadata[0].name

    labels = {
      app = "kafka-ui"
    }
  }

  # Ensure Kafka (installed via Helm) is ready
  # before deploying Kafka UI
  depends_on = [
    helm_release.kafka
  ]

  # Deployment specification
  spec {

    # Number of Kafka UI replicas
    replicas = 1

    # Selector: must match pod template labels
    selector {
      match_labels = {
        app = "kafka-ui"
      }
    }

    # Pod template
    template {

      # Pod labels
      metadata {
        labels = {
          app = "kafka-ui"
        }
      }

      # Pod specification
      spec {

        # Schedule Kafka UI pod on a specific
        # Kubernetes node pool (DigitalOcean)
        node_selector = {
          "doks.digitalocean.com/node-pool" = var.kubernetes_primary_node_pool_name
        }

        # Kafka UI container definition
        container {
          name  = "kafka-ui"
          image = "provectuslabs/kafka-ui:latest"

          # Expose Kafka UI web port
          port {
            container_port = local.kafka_ui_service.port
          }

          # Kafka UI configuration
          # (Kafka cluster connection)

          # Logical name of Kafka cluster
          env {
            name  = "KAFKA_CLUSTERS_0_NAME"
            value = "kafka"
          }

          # Kafka bootstrap servers
          # Usually points to Kafka Service inside the cluster
          env {
            name  = "KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS"
            value = "${local.kafka_service.host}:${local.kafka_service.port}"
          }

          # Security protocol used by Kafka
          env {
            name  = "KAFKA_CLUSTERS_0_PROPERTIES_SECURITY_PROTOCOL"
            value = "SASL_PLAINTEXT"
          }

          # SASL mechanism for authentication
          env {
            name  = "KAFKA_CLUSTERS_0_PROPERTIES_SASL_MECHANISM"
            value = "SCRAM-SHA-256"
          }

          # SASL JAAS configuration
          # Uses Kafka username and password
          env {
            name  = "KAFKA_CLUSTERS_0_PROPERTIES_SASL_JAAS_CONFIG"
            value = "org.apache.kafka.common.security.scram.ScramLoginModule required username=\"${var.kafka_sasl_user}\" password=\"${var.kafka_sasl_password}\";"
          }

          # Resource requests & limits
          # (important for scheduling & stability)
          resources {
            requests = {
              cpu    = local.kafka.kafka_ui.request_cpu
              memory = local.kafka.kafka_ui.request_memory
            }

            limits = {
              cpu    = local.kafka.kafka_ui.limit_cpu
              memory = local.kafka.kafka_ui.limit_memory
            }
          }
        }
      }
    }
  }
}

// UI Service 
resource "kubernetes_service" "kafka_ui" {
  metadata {
    name = "kafka-ui"
    namespace = kubernetes_namespace.kafka.metadata[0].name
  }
  spec {
    selector = {
      app = "kafka-ui"
    }
    port {
      port = local.kafka_ui_service.port
      target_port = local.kafka_ui_service.port
    }
  }
}

// =========================
// Kafka UI Basic Auth Secret
// =========================
// Creates a Kubernetes secret containing htpasswd file for basic authentication.
resource "kubernetes_secret" "kafka_ui_basic_auth" {
  metadata {
    name      = "kafka-ui-basic-auth"
    namespace = kubernetes_namespace.kafka.metadata[0].name
  }
  data = {
    auth = var.kafka_ui_htpasswd
  }
  type = "Opaque"
}
// =========================
// Kafka UI Ingress
// =========================
// Exposes Kafka UI via NGINX Ingress with TLS
// managed by cert-manager and DNS handled by Cloudflare.
resource "kubernetes_ingress_v1" "kafka_ui" {
  metadata {
    name      = "kafka-ui"
    namespace = kubernetes_namespace.kafka.metadata[0].name

    annotations = {
      "cert-manager.io/cluster-issuer"                 = var.cert_manager_cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "acme.cert-manager.io/http01-edit-in-place"      = "true"
      "nginx.ingress.kubernetes.io/auth-type"           = "basic"
      "nginx.ingress.kubernetes.io/auth-secret"         = kubernetes_secret.kafka_ui_basic_auth.metadata[0].name
      "nginx.ingress.kubernetes.io/auth-realm"          = "Kafka UI Authentication Required"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = local.kafka_ui_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              name = kubernetes_service.kafka_ui.metadata[0].name
              port {
                number = local.kafka_ui_service.port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.kafka_ui_domain_name]
      secret_name = "kafka-ui-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.kafka_ui,
    helm_release.kafka,
    kubernetes_service.kafka_ui
  ]
}