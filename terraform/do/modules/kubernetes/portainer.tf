// =========================
// Namespace for Portainer
// =========================
// Creates a dedicated namespace to isolate Portainer
// and its related resources from application workloads.
resource "kubernetes_namespace" "portainer" {
  metadata {
    name = "portainer"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// Portainer local identifiers
// =========================
// Defines naming conventions shared across Helm, Service lookup,
// and Ingress configuration.
locals {
  // Helm release name for Portainer
  portainer_name = "portainer"

  // Service name exposed by the Portainer server component
  // (created by the Portainer Helm chart)
  portainer_server_service_name = "portainer"
}

// =========================
// Portainer Helm release
// =========================
// Deploys Portainer using the official Portainer Helm chart.
// All configuration is injected via a Terraform-rendered values file.
resource "helm_release" "portainer" {
  name      = local.portainer_name
  namespace = kubernetes_namespace.portainer.metadata[0].name

  // Official Portainer Helm chart
  repository = "https://portainer.github.io/k8s/"
  chart      = "portainer"

  // Render Helm values from template and inject Terraform variables
  values = [
    templatefile("${path.module}/yamls/portainer.yaml", {
      // =========================
      // Portainer server resources
      // =========================
      request_cpu    = local.portainer.portainer.request_cpu
      request_memory = local.portainer.portainer.request_memory
      limit_cpu      = local.portainer.portainer.limit_cpu
      limit_memory   = local.portainer.portainer.limit_memory
      persistence_size = var.portainer_persistence_size
      // =========================
      // Node scheduling
      // =========================
      // Ensures Portainer pods are scheduled onto the primary node pool
      node_pool_label = var.kubernetes_primary_node_pool_name
    })
  ]

  // Ensure the Portainer namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.portainer
  ]
}

// =========================
// Read Portainer server Service
// =========================
// Fetches the Service created by the Portainer Helm chart.
// This is used to dynamically retrieve service ports
// for Ingress configuration.
data "kubernetes_service" "portainer_server" {
  metadata {
    name      = local.portainer_server_service_name
    namespace = kubernetes_namespace.portainer.metadata[0].name
  }

  depends_on = [helm_release.portainer]
}

// =========================
// Portainer service port resolution
// =========================
// Selects the HTTP port (9000) if available.
// Falls back to the first declared service port
// to avoid Terraform apply failures if the chart changes.
locals {
  portainer_server_port = try(
    one([
      for p in data.kubernetes_service.portainer_server.spec[0].port :
      p.port if p.port == 9000
    ]),
    data.kubernetes_service.portainer_server.spec[0].port[0].port
  )
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
      "cert-manager.io/cluster-issuer"                 = var.cert_manager_cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "acme.cert-manager.io/http01-edit-in-place"      = "true"
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
                number = local.portainer_server_port
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
