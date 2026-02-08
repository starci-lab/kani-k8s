// =========================
// Read kube-prometheus server Service
// =========================
// Fetches the Service created by the kube-prometheus Helm chart.
// This is used to dynamically retrieve service ports for Ingress configuration.
data "kubernetes_service" "kube_prometheus_server" {
  metadata {
    name      = local.kube_prometheus.services.server_service.name
    namespace = kubernetes_namespace.kube_prometheus.metadata[0].name
  }
  depends_on = [helm_release.kube_prometheus]
}

// =========================
// Read kube-prometheus Alertmanager server Service
// =========================
// Fetches the Service created by the kube-prometheus Helm chart.
// This is used to dynamically retrieve service ports for Ingress configuration.
data "kubernetes_service" "kube_prometheus_alertmanager_server" {
  metadata {
    name      = local.kube_prometheus.services.alertmanager_server_service.name
    namespace = kubernetes_namespace.kube_prometheus.metadata[0].name
  }
  depends_on = [helm_release.kube_prometheus]
}

// =========================
// kube-prometheus Basic Auth Secret
// =========================
// Creates a Kubernetes secret containing htpasswd file for basic authentication.
resource "kubernetes_secret" "prometheus_basic_auth" {
  metadata {
    name      = "prometheus-basic-auth"
    namespace = kubernetes_namespace.kube_prometheus.metadata[0].name
  }
  data = {
    auth = var.kube_prometheus_htpasswd
  }
  type = "Opaque"
}

// =========================
// kube-prometheus Ingress
// =========================
// Exposes kube-prometheus UI and API via NGINX Ingress with TLS
// managed by cert-manager and DNS handled by Cloudflare.
// Basic authentication is enabled via NGINX Ingress annotations.
resource "kubernetes_ingress_v1" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = kubernetes_namespace.kube_prometheus.metadata[0].name

    annotations = {
      "cert-manager.io/cluster-issuer"                 = var.cert_manager_cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "acme.cert-manager.io/http01-edit-in-place"      = "true"
      "nginx.ingress.kubernetes.io/auth-type"          = "basic"
      "nginx.ingress.kubernetes.io/auth-secret"        = kubernetes_secret.prometheus_basic_auth.metadata[0].name
      "nginx.ingress.kubernetes.io/auth-realm"         = "Prometheus Authentication Required"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = local.prometheus_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              // Dynamically resolved kube-prometheus service + port
              name = data.kubernetes_service.kube_prometheus_server.metadata[0].name
              port {
                number = local.kube_prometheus_outputs.server_service.port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.prometheus_domain_name]
      secret_name = "prometheus-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.prometheus,
    helm_release.kube_prometheus,
    kubernetes_secret.prometheus_basic_auth
  ]
}

// =========================
// kube-prometheus Alertmanager Basic Auth Secret
// =========================
// Creates a Kubernetes secret containing htpasswd file for basic authentication.
resource "kubernetes_secret" "prometheus_alertmanager_basic_auth" {
  metadata {
    name      = "prometheus-alertmanager-basic-auth"
    namespace = kubernetes_namespace.kube_prometheus.metadata[0].name
  }
  data = {
    auth = var.kube_prometheus_alertmanager_htpasswd
  }
  type = "Opaque"
}

// =========================
// kube-prometheus Alertmanager Ingress
// =========================
// Exposes kube-prometheus Alertmanager UI and API via NGINX Ingress with TLS
// managed by cert-manager and DNS handled by Cloudflare.
// Basic authentication is enabled via NGINX Ingress annotations.
resource "kubernetes_ingress_v1" "prometheus_alertmanager" {
  metadata {
    name      = "prometheus-alertmanager"
    namespace = kubernetes_namespace.kube_prometheus.metadata[0].name

    annotations = {
      "cert-manager.io/cluster-issuer"                 = var.cert_manager_cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "acme.cert-manager.io/http01-edit-in-place"      = "true"
      "nginx.ingress.kubernetes.io/auth-type"          = "basic"
      "nginx.ingress.kubernetes.io/auth-secret"        = kubernetes_secret.prometheus_alertmanager_basic_auth.metadata[0].name
      "nginx.ingress.kubernetes.io/auth-realm"         = "Prometheus Authentication Required"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = local.prometheus_alertmanager_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              // Dynamically resolved kube-prometheus service + port
              name = data.kubernetes_service.kube_prometheus_alertmanager_server.metadata[0].name
              port {
                number = local.kube_prometheus_outputs.alertmanager_server_service.port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.prometheus_alertmanager_domain_name]
      secret_name = "prometheus-alertmanager-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.prometheus_alertmanager,
    helm_release.kube_prometheus,
    kubernetes_secret.prometheus_alertmanager_basic_auth
  ]
}
