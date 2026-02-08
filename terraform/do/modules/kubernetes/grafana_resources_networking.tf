// =========================
// Read Grafana server Service
// =========================
// Fetches the Service created by the Grafana Helm chart.
// This is used to dynamically retrieve service ports for Ingress configuration.
data "kubernetes_service" "grafana_server" {
  metadata {
    name      = local.grafana.server_service_name
    namespace = kubernetes_namespace.grafana.metadata[0].name
  }

  depends_on = [helm_release.grafana]
}

// =========================
// Grafana Ingress
// =========================
// Exposes Grafana UI via NGINX Ingress with TLS
// managed by cert-manager and DNS handled by Cloudflare.
resource "kubernetes_ingress_v1" "grafana" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace.grafana.metadata[0].name

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
      host = local.grafana_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              // Dynamically resolved Grafana service + port
              name = data.kubernetes_service.grafana_server.metadata[0].name
              port {
                number = local.grafana_outputs.server_port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.grafana_domain_name]
      secret_name = "grafana-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.grafana,
    helm_release.grafana
  ]
}
