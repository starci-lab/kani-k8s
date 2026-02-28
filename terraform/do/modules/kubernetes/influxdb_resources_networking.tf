// =========================
// InfluxDB Ingress (NGINX + TLS)
// =========================
// Exposes InfluxDB HTTP API at influxdb.<domain> (e.g. influxdb.kanibot.xyz).
// TLS is managed by cert-manager; DNS A record is created in cloudflare_dns.tf.
resource "kubernetes_ingress_v1" "influxdb" {
  metadata {
    name      = "influxdb"
    namespace = kubernetes_namespace.influxdb.metadata[0].name

    annotations = {
      "cert-manager.io/cluster-issuer"                  = var.cert_manager_cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"         = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "acme.cert-manager.io/http01-edit-in-place"       = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = local.influxdb_domain_name

      http {
        path {
          path = "/"

          backend {
            service {
              name = data.kubernetes_service.influxdb.metadata[0].name
              port {
                number = local.influxdb.services.server_service.port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.influxdb_domain_name]
      secret_name = "influxdb-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.influxdb,
    helm_release.influxdb,
  ]
}
