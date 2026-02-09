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
// Loki Gateway Basic Auth Secret
// =========================
// Creates a Kubernetes secret containing htpasswd file for basic authentication.
resource "kubernetes_secret" "loki_gateway_basic_auth" {
  metadata {
    name      = "loki-gateway-basic-auth"
    namespace = kubernetes_namespace.loki.metadata[0].name
  }
  data = {
    auth = var.loki_gateway_htpasswd
  }
  type = "Opaque"
}

// =========================
// Loki Gateway Ingress
// =========================
// Exposes Loki Gateway via NGINX Ingress with TLS
// managed by cert-manager and DNS handled by Cloudflare.
// Basic authentication is enabled via NGINX Ingress annotations.
resource "kubernetes_ingress_v1" "loki_gateway" {
  metadata {
    name      = "loki-gateway"
    namespace = kubernetes_namespace.loki.metadata[0].name

    annotations = {
      "cert-manager.io/cluster-issuer"                 = var.cert_manager_cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "acme.cert-manager.io/http01-edit-in-place"      = "true"
      "nginx.ingress.kubernetes.io/auth-type"          = "basic"
      "nginx.ingress.kubernetes.io/auth-secret"        = kubernetes_secret.loki_gateway_basic_auth.metadata[0].name
      "nginx.ingress.kubernetes.io/auth-realm"         = "Loki Gateway Authentication Required"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = local.loki_gateway_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              // Dynamically resolved Loki Gateway service + port
              name = data.kubernetes_service.loki_gateway.metadata[0].name
              port {
                number = data.kubernetes_service.loki_gateway.spec[0].port[0].port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.loki_gateway_domain_name]
      secret_name = "loki-gateway-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.loki_gateway,
    helm_release.loki,
    data.kubernetes_service.loki_gateway,
    kubernetes_secret.loki_gateway_basic_auth
  ]
}
