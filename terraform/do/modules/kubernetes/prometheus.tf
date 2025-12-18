// =========================
// Namespace for Prometheus
// =========================
// Creates a dedicated namespace to isolate the Prometheus
// and its related resources from application workloads.
resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "prometheus"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// Prometheus local identifiers
// =========================
// Defines naming conventions shared across Helm, Service lookup,
// and Ingress configuration.
locals {
  // Helm release name for Prometheus
  prometheus_name = "kube-prometheus"

  // Service name exposed by the Prometheus server component
  // (created by the Bitnami Helm chart)
  prometheus_server_service_name = "kube-prometheus-prometheus"

  // Service name exposed by the Prometheus Alertmanager server component
  // (created by the Bitnami Helm chart)
  prometheus_alertmanager_server_service_name = "kube-prometheus-alertmanager"
}

// =========================
// Prometheus Helm release
// =========================
// Deploys Prometheus using the Bitnami OCI Helm chart.
// All configuration is injected via a Terraform-rendered values file.
resource "helm_release" "prometheus" {
  name      = local.prometheus_name
  namespace = kubernetes_namespace.prometheus.metadata[0].name

  // Bitnami kube-prometheus chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/kube-prometheus"

  // Render Helm values from template and inject Terraform variables
  values = [
    templatefile("${path.module}/yamls/prometheus.yaml", {

      // =========================
      // Prometheus Operator resources
      // =========================
      operator_request_cpu    = var.operator_request_cpu
      operator_request_memory = var.operator_request_memory
      operator_limit_cpu      = var.operator_limit_cpu
      operator_limit_memory   = var.operator_limit_memory

      // =========================
      // Prometheus server resources
      // =========================
      prometheus_request_cpu    = var.prometheus_request_cpu
      prometheus_request_memory = var.prometheus_request_memory
      prometheus_limit_cpu      = var.prometheus_limit_cpu
      prometheus_limit_memory   = var.prometheus_limit_memory

      // =========================
      // Prometheus persistence
      // =========================
      prometheus_persistence_size = var.prometheus_persistence_size

      // =========================
      // Thanos sidecar resources
      // =========================
      thanos_request_cpu    = var.thanos_request_cpu
      thanos_request_memory = var.thanos_request_memory
      thanos_limit_cpu      = var.thanos_limit_cpu
      thanos_limit_memory   = var.thanos_limit_memory

      // =========================
      // Alertmanager resources
      // =========================
      alertmanager_request_cpu    = var.alertmanager_request_cpu
      alertmanager_request_memory = var.alertmanager_request_memory
      alertmanager_limit_cpu      = var.alertmanager_limit_cpu
      alertmanager_limit_memory   = var.alertmanager_limit_memory

      // =========================
      // Alertmanager persistence
      // =========================
      alertmanager_persistence_size = var.alertmanager_persistence_size

      // =========================
      // Blackbox Exporter resources
      // =========================
      blackbox_exporter_request_cpu    = var.blackbox_exporter_request_cpu
      blackbox_exporter_request_memory = var.blackbox_exporter_request_memory
      blackbox_exporter_limit_cpu      = var.blackbox_exporter_limit_cpu
      blackbox_exporter_limit_memory   = var.blackbox_exporter_limit_memory

      // =========================
      // Thanos Ruler resources
      // =========================
      thanos_ruler_request_cpu    = var.thanos_ruler_request_cpu
      thanos_ruler_request_memory = var.thanos_ruler_request_memory
      thanos_ruler_limit_cpu      = var.thanos_ruler_limit_cpu
      thanos_ruler_limit_memory   = var.thanos_ruler_limit_memory

      // =========================
      // Node scheduling
      // =========================
      // Ensures Prometheus pods are scheduled onto the primary node pool
      node_pool_label = var.kubernetes_primary_node_pool_name
    })
  ]

  // Ensure the Prometheus namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.prometheus
  ]
}

// =========================
// Read Prometheus server Service
// =========================
// Fetches the Service created by the Prometheus Helm chart.
// This is used to dynamically retrieve service ports
// for Ingress configuration.
data "kubernetes_service" "prometheus_server" {
  metadata {
    name      = local.prometheus_server_service_name
    namespace = kubernetes_namespace.prometheus.metadata[0].name
  }
  depends_on = [helm_release.prometheus]
}

data "kubernetes_service" "prometheus_alertmanager_server" {
  metadata {
    name      = local.prometheus_alertmanager_server_service_name
    namespace = kubernetes_namespace.prometheus.metadata[0].name
  }
  depends_on = [helm_release.prometheus]
}

// =========================
// Prometheus service port resolution
// =========================
// Selects the HTTP port (9090) if available.
// Falls back to the first declared service port
// to avoid Terraform apply failures if the chart changes.
locals {
  prometheus_server_port = try(
    one([
      for p in data.kubernetes_service.prometheus_server.spec[0].port :
      p.port if p.port == 9090
    ]),
    data.kubernetes_service.prometheus_server.spec[0].port[0].port
  )
  prometheus_alertmanager_server_port = try(
    one([
      for p in data.kubernetes_service.prometheus_alertmanager_server.spec[0].port :
      p.port if p.port == 9093
    ]),
    data.kubernetes_service.prometheus_alertmanager_server.spec[0].port[0].port
  )
}

// =========================
// Prometheus Basic Auth Secret
// =========================
// Creates a Kubernetes secret containing htpasswd file for basic authentication.
resource "kubernetes_secret" "prometheus_basic_auth" {
  metadata {
    name      = "prometheus-basic-auth"
    namespace = kubernetes_namespace.prometheus.metadata[0].name
  }
  data = {
    auth = var.prometheus_htpasswd
  }
  type = "Opaque"
}

// =========================
// Prometheus Ingress
// =========================
// Exposes Prometheus UI and API via NGINX Ingress with TLS
// managed by cert-manager and DNS handled by Cloudflare.
// Basic authentication is enabled via NGINX Ingress annotations.
resource "kubernetes_ingress_v1" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = kubernetes_namespace.prometheus.metadata[0].name

    annotations = {
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-prod"
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
              // Dynamically resolved Prometheus service + port
              name = data.kubernetes_service.prometheus_server.metadata[0].name
              port {
                number = local.prometheus_server_port
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
    helm_release.prometheus,
    kubernetes_secret.prometheus_basic_auth
  ]
}

// =========================
// Prometheus Alertmanager Basic Auth Secret
// =========================
// Creates a Kubernetes secret containing htpasswd file for basic authentication.
resource "kubernetes_secret" "prometheus_alertmanager_basic_auth" {
  metadata {
    name      = "prometheus-alertmanager-basic-auth"
    namespace = kubernetes_namespace.prometheus.metadata[0].name
  }
  data = {
    auth = var.prometheus_alertmanager_htpasswd
  }
  type = "Opaque"
}

// =========================
// Prometheus Alertmanager Ingress
// =========================
// Exposes Prometheus Alertmanager UI and API via NGINX Ingress with TLS
// managed by cert-manager and DNS handled by Cloudflare.
// Basic authentication is enabled via NGINX Ingress annotations.
resource "kubernetes_ingress_v1" "prometheus_alertmanager" {
  metadata {
    name      = "prometheus-alertmanager"
    namespace = kubernetes_namespace.prometheus.metadata[0].name

    annotations = {
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-prod"
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
              // Dynamically resolved Prometheus service + port
              name = data.kubernetes_service.prometheus_alertmanager_server.metadata[0].name
              port {
                number = local.prometheus_alertmanager_server_port
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
    helm_release.prometheus,
    kubernetes_secret.prometheus_alertmanager_basic_auth
  ]
}