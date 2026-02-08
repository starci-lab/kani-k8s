// =========================
// Loki Gateway Service (data)
// =========================
// Used to build the Loki service address for clients.
data "kubernetes_service" "loki_gateway" {
  metadata {
    name      = local.loki.services.gateway_service.name
    namespace = kubernetes_namespace.loki.metadata[0].name
  }

  depends_on = [helm_release.loki]
}

// =========================
// Loki Ingress
// =========================
// Exposes Loki Gateway via NGINX Ingress with TLS
// managed by cert-manager and DNS handled by Cloudflare.
resource "kubernetes_ingress_v1" "loki" {
  metadata {
    name      = "loki"
    namespace = kubernetes_namespace.loki.metadata[0].name

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
      host = local.loki_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              // Dynamically resolved Loki Gateway service + port
              name = data.kubernetes_service.loki_gateway.metadata[0].name
              port {
                number = local.loki_outputs.service.port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.loki_domain_name]
      secret_name = "loki-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.loki,
    helm_release.loki,
    data.kubernetes_service.loki_gateway
  ]
}
