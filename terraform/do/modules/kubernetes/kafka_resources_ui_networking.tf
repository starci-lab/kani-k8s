// =========================
// Read Kafka UI Service
// =========================
// Fetches the Service created for Kafka UI.
// This is used to dynamically retrieve service ports for Ingress configuration.
data "kubernetes_service" "kafka_ui" {
  metadata {
    name      = "kafka-ui"
    namespace = kubernetes_namespace.kafka.metadata[0].name
  }

  depends_on = [kubernetes_service.kafka_ui]
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
// Basic authentication is enabled via NGINX Ingress annotations.
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
      "nginx.ingress.kubernetes.io/auth-secret"        = kubernetes_secret.kafka_ui_basic_auth.metadata[0].name
      "nginx.ingress.kubernetes.io/auth-realm"         = "Kafka UI Authentication Required"
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
              // Dynamically resolved Kafka UI service + port
              name = data.kubernetes_service.kafka_ui.metadata[0].name
              port {
                number = local.kafka_outputs.ui_service.port
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
    kubernetes_service.kafka_ui,
    kubernetes_secret.kafka_ui_basic_auth
  ]
}
