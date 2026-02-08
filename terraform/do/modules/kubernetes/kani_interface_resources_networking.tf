// =========================
// Kani Interface server Service (data)
// =========================
// Fetches the Service created by the Kani Interface Helm chart.
// This is used to dynamically retrieve service ports for Ingress configuration.
data "kubernetes_service" "kani_interface" {
  metadata {
    name      = "kani-interface-service"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  depends_on = [helm_release.kani_interface]
}

// =========================
// Kani Interface server port (for Ingress)
// =========================
// Computes the server port from the Service data source.
// Falls back to the first available port if the configured port is not found.
locals {
  kani_interface_server_port = coalesce(
    try(
      [
        for p in data.kubernetes_service.kani_interface.spec[0].port :
        p.port
        if p.port == tonumber(var.kani_interface_port)
      ][0],
      null
    ),
    data.kubernetes_service.kani_interface.spec[0].port[0].port
  )
}

// =========================
// Kani Interface Ingress (NGINX + TLS)
// =========================
// Exposes Kani Interface API via NGINX Ingress with TLS
// managed by cert-manager and DNS handled by Cloudflare.
resource "kubernetes_ingress_v1" "kani_interface" {
  metadata {
    name      = "kani-interface"
    namespace = kubernetes_namespace.kani.metadata[0].name

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
      host = local.api_domain_name

      http {
        path {
          path = "/"

          backend {
            service {
              name = data.kubernetes_service.kani_interface.metadata[0].name
              port {
                number = local.kani_interface_server_port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.api_domain_name]
      secret_name = "kani-interface-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.api,
    helm_release.kani_interface
  ]
}
