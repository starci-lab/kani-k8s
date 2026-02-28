// =========================
// Kani Inspector server Service (data)
// =========================
// Fetches the Service created by the Kani Inspector Helm chart.
// Chart creates service with name = release name (kani-inspector).
data "kubernetes_service" "kani_inspector" {
  metadata {
    name      = "kani-inspector-service"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  depends_on = [helm_release.kani_inspector]
}

// =========================
// Kani Inspector server port (for Ingress)
// =========================
locals {
  kani_inspector_server_port = coalesce(
    try(
      [
        for p in data.kubernetes_service.kani_inspector.spec[0].port :
        p.port
        if p.port == tonumber(var.kani_inspector_port)
      ][0],
      null
    ),
    data.kubernetes_service.kani_inspector.spec[0].port[0].port
  )
}

// =========================
// Kani Inspector Ingress (NGINX + TLS)
// =========================
// Exposes Kani Inspector API via NGINX Ingress when kani_inspector_ingress_host is set.
resource "kubernetes_ingress_v1" "kani_inspector" {
  count = var.kani_inspector_ingress_host != "" ? 1 : 0

  metadata {
    name      = "kani-inspector"
    namespace = kubernetes_namespace.kani.metadata[0].name

    annotations = {
      "cert-manager.io/cluster-issuer"                 = var.cert_manager_cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"        = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "acme.cert-manager.io/http01-edit-in-place"       = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = var.kani_inspector_ingress_host

      http {
        path {
          path = "/"

          backend {
            service {
              name = data.kubernetes_service.kani_inspector.metadata[0].name
              port {
                number = local.kani_inspector_server_port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [var.kani_inspector_ingress_host]
      secret_name = "kani-inspector-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    helm_release.kani_inspector
  ]
}
