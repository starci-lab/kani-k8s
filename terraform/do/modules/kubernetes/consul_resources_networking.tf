// =========================
// Consul Basic Auth Secret
// =========================
// Creates a Kubernetes secret containing htpasswd file for basic authentication.
resource "kubernetes_secret" "consul_basic_auth" {
  metadata {
    name      = "consul-basic-auth"
    namespace = kubernetes_namespace.consul.metadata[0].name
  }
  data = {
    auth = var.consul_htpasswd
  }
  type = "Opaque"
}

// =========================
// Consul Ingress
// =========================
// Exposes Consul UI via NGINX Ingress with TLS
// managed by cert-manager and DNS handled by Cloudflare.
// Basic authentication is enabled via NGINX Ingress annotations.
resource "kubernetes_ingress_v1" "consul_ui" {
  metadata {
    name      = "consul-ui"
    namespace = kubernetes_namespace.consul.metadata[0].name

    annotations = {
      "cert-manager.io/cluster-issuer"                  = var.cert_manager_cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"        = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect"  = "true"
      "acme.cert-manager.io/http01-edit-in-place"       = "true"
      "nginx.ingress.kubernetes.io/auth-type"            = "basic"
      "nginx.ingress.kubernetes.io/auth-secret"        = kubernetes_secret.consul_basic_auth.metadata[0].name
      "nginx.ingress.kubernetes.io/auth-realm"         = "Consul UI Authentication Required"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = local.consul_ui_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              // Dynamically resolved Consul service + port
              name = data.kubernetes_service.consul_ui.metadata[0].name
              port {
                number = local.consul_outputs.ui_service.port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.consul_ui_domain_name]
      secret_name = "consul-ui-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.consul_ui,
    helm_release.consul,
    kubernetes_secret.consul_basic_auth
  ]
}
