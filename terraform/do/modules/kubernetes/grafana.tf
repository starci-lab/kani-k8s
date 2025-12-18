// =========================
// Namespace for Grafana
// =========================
// Creates a dedicated namespace to isolate Grafana
// and its related resources from application workloads.
resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "grafana"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// Grafana local identifiers
// =========================
// Defines naming conventions shared across Helm, Service lookup,
// and Ingress configuration.
locals {
  // Helm release name for Grafana
  grafana_name = "grafana"

  // Service name exposed by the Grafana server component
  // (created by the Bitnami Helm chart)
  grafana_server_service_name = "grafana"
}

// =========================
// Grafana Helm release
// =========================
// Deploys Grafana using the Bitnami OCI Helm chart.
// All configuration is injected via a Terraform-rendered values file.
resource "helm_release" "grafana" {
  name      = local.grafana_name
  namespace = kubernetes_namespace.grafana.metadata[0].name

  // Bitnami Grafana chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/grafana"

  // Render Helm values from template and inject Terraform variables
  values = [
    templatefile("${path.module}/yamls/grafana.yaml", {
      // =========================
      // Admin credentials
      // =========================
      grafana_user     = var.grafana_user
      grafana_password = var.grafana_password

      // =========================
      // Grafana server resources
      // =========================
      request_cpu    = var.grafana_request_cpu
      request_memory = var.grafana_request_memory
      limit_cpu      = var.grafana_limit_cpu
      limit_memory   = var.grafana_limit_memory
      persistence_size = var.grafana_persistence_size

      // =========================
      // Prometheus datasource
      // =========================
      prometheus_url                  = var.prometheus_url
      prometheus_basic_auth_username  = var.prometheus_basic_auth_username
      prometheus_basic_auth_password = var.prometheus_basic_auth_password
      // =========================
      // Alertmanager datasource
      // =========================
      prometheus_alertmanager_url                  = var.prometheus_alertmanager_url
      prometheus_alertmanager_basic_auth_username  = var.prometheus_alertmanager_basic_auth_username
      prometheus_alertmanager_basic_auth_password = var.prometheus_alertmanager_basic_auth_password
      // =========================
      // Node scheduling
      // =========================
      // Ensures Grafana pods are scheduled onto the primary node pool
      node_pool_label = var.kubernetes_primary_node_pool_name
    })
  ]

  // Ensure the Grafana namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.grafana
  ]
}

// =========================
// Read Grafana server Service
// =========================
// Fetches the Service created by the Grafana Helm chart.
// This is used to dynamically retrieve service ports
// for Ingress configuration.
data "kubernetes_service" "grafana_server" {
  metadata {
    name      = local.grafana_server_service_name
    namespace = kubernetes_namespace.grafana.metadata[0].name
  }

  depends_on = [helm_release.grafana]
}

// =========================
// Grafana service port resolution
// =========================
// Selects the HTTP port (3000) if available.
// Falls back to the first declared service port
// to avoid Terraform apply failures if the chart changes.
locals {
  grafana_server_port = try(
    one([
      for p in data.kubernetes_service.grafana_server.spec[0].port :
      p.port if p.port == 3000
    ]),
    data.kubernetes_service.grafana_server.spec[0].port[0].port
  )
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
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-prod"
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
                number = local.grafana_server_port
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
