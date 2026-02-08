// =========================
// Read Portainer server Service
// =========================
// Fetches the Service created by the Portainer Helm chart.
// This is used to dynamically retrieve service ports for Ingress configuration.
data "kubernetes_service" "portainer_server" {
  metadata {
    name      = local.portainer.server_service_name
    namespace = kubernetes_namespace.portainer.metadata[0].name
  }

  depends_on = [helm_release.portainer]
}

// =========================
// Portainer Ingress
// =========================
// Exposes Portainer UI via NGINX Ingress with TLS
// managed by cert-manager and DNS handled by Cloudflare.
resource "kubernetes_ingress_v1" "portainer" {
  metadata {
    name      = "portainer"
    namespace = kubernetes_namespace.portainer.metadata[0].name

    annotations = {
      "cert-manager.io/cluster-issuer"                  = var.cert_manager_cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"        = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect"  = "true"
      "acme.cert-manager.io/http01-edit-in-place"       = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = local.portainer_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              // Dynamically resolved Portainer service + port
              name = data.kubernetes_service.portainer_server.metadata[0].name
              port {
                number = local.portainer.server_port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.portainer_domain_name]
      secret_name = "portainer-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.portainer,
    helm_release.portainer
  ]
}
