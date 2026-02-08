// =========================
// Kafka UI Deployment
// =========================
// Runs Kafka UI (Provectus) for monitoring and managing the Kafka cluster.
// The cluster is deployed separately via Helm above.
resource "kubernetes_deployment" "kafka_ui" {
  metadata {
    name      = "kafka-ui"
    namespace = kubernetes_namespace.kafka.metadata[0].name

    labels = {
      app = "kafka-ui"
    }
  }

  depends_on = [
    helm_release.kafka
  ]

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "kafka-ui"
      }
    }
    template {
      metadata {
        labels = {
          app = "kafka-ui"
        }
      }
      spec {
        node_selector = {
          "doks.digitalocean.com/node-pool" = var.kubernetes_primary_node_pool_name
        }
        container {
          name  = "kafka-ui"
          image = "provectuslabs/kafka-ui:latest"
          port {
            container_port = local.kafka.ui_service.port
          }
          env {
            name  = "KAFKA_CLUSTERS_0_NAME"
            value = "kafka"
          }
          env {
            name  = "KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS"
            value = "${local.kafka.service.host}:${local.kafka.service.port}"
          }
          env {
            name  = "KAFKA_CLUSTERS_0_PROPERTIES_SECURITY_PROTOCOL"
            value = "SASL_PLAINTEXT"
          }
          env {
            name  = "KAFKA_CLUSTERS_0_PROPERTIES_SASL_MECHANISM"
            value = "SCRAM-SHA-256"
          }
          env {
            name  = "KAFKA_CLUSTERS_0_PROPERTIES_SASL_JAAS_CONFIG"
            value = "org.apache.kafka.common.security.scram.ScramLoginModule required username=\"${var.kafka_sasl_user}\" password=\"${var.kafka_sasl_password}\";"
          }
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

// =========================
// Kafka UI Service
// =========================
resource "kubernetes_service" "kafka_ui" {
  metadata {
    name      = "kafka-ui"
    namespace = kubernetes_namespace.kafka.metadata[0].name
  }
  spec {
    selector = {
      app = "kafka-ui"
    }
    port {
      port        = local.kafka.ui_service.port
      target_port = local.kafka.ui_service.port
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
      "nginx.ingress.kubernetes.io/auth-type"          = "basic"
      "nginx.ingress.kubernetes.io/auth-secret"         = kubernetes_secret.kafka_ui_basic_auth.metadata[0].name
      "nginx.ingress.kubernetes.io/auth-realm"        = "Kafka UI Authentication Required"
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
                number = local.kafka.ui_service.port
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
