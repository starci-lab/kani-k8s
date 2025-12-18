// =========================
// Namespace for Argo CD
// =========================
// Creates a dedicated namespace to isolate all Argo CD resources.
resource "kubernetes_namespace" "argo_cd" {
  metadata {
    name = "argo-cd"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// Argo CD local identifiers
// =========================
// Defines naming conventions shared across Helm, Service lookup,
// and Ingress configuration.
locals {
  // Helm release name for Argo CD
  argo_cd_name = "argo-cd"

  // Service name exposed by the Argo CD server component
  // (created by the Bitnami Helm chart)
  argo_cd_server_service_name = "argo-cd-server"
}

// =========================
// Argo CD Helm release
// =========================
// Deploys Argo CD using the Bitnami OCI Helm chart.
// All configuration is injected via a Terraform-rendered values file.
resource "helm_release" "argo_cd" {
  name      = local.argo_cd_name
  namespace = kubernetes_namespace.argo_cd.metadata[0].name

  // Bitnami Argo CD chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/argo-cd"

  // Render Helm values from template and inject Terraform variables
  values = [
    templatefile("${path.module}/yamls/argo-cd.yaml", {

      // =========================
      // Admin authentication
      // =========================
      // NOTE: Username is always "admin"; password must be bcrypt-hashed
      admin_password = var.argo_cd_admin_password

      // =========================
      // Application controller
      // =========================
      controller_replica_count  = var.argo_cd_controller_replica_count
      controller_request_cpu    = var.argo_cd_controller_request_cpu
      controller_request_memory = var.argo_cd_controller_request_memory
      controller_limit_cpu      = var.argo_cd_controller_limit_cpu
      controller_limit_memory   = var.argo_cd_controller_limit_memory

      // =========================
      // ApplicationSet controller
      // =========================
      application_set_request_cpu    = var.argo_cd_application_set_request_cpu
      application_set_request_memory = var.argo_cd_application_set_request_memory
      application_set_limit_cpu      = var.argo_cd_application_set_limit_cpu
      application_set_limit_memory   = var.argo_cd_application_set_limit_memory

      // =========================
      // Notifications controller
      // =========================
      notifications_request_cpu    = var.argo_cd_notifications_request_cpu
      notifications_request_memory = var.argo_cd_notifications_request_memory
      notifications_limit_cpu      = var.argo_cd_notifications_limit_cpu
      notifications_limit_memory   = var.argo_cd_notifications_limit_memory

      // =========================
      // Argo CD API / UI server
      // =========================
      server_request_cpu    = var.argo_cd_server_request_cpu
      server_request_memory = var.argo_cd_server_request_memory
      server_limit_cpu      = var.argo_cd_server_limit_cpu
      server_limit_memory   = var.argo_cd_server_limit_memory

      // =========================
      // Repo-server
      // =========================
      repo_server_request_cpu    = var.argo_cd_repo_server_request_cpu
      repo_server_request_memory = var.argo_cd_repo_server_request_memory
      repo_server_limit_cpu      = var.argo_cd_repo_server_limit_cpu
      repo_server_limit_memory   = var.argo_cd_repo_server_limit_memory

      // =========================
      // External Redis
      // =========================
      redis_host     = var.argo_cd_redis_host
      redis_password = var.argo_cd_redis_password
    })
  ]

  // Ensure Redis and namespace exist before installing Argo CD
  depends_on = [
    helm_release.redis_cluster,
    kubernetes_namespace.argo_cd
  ]
}

// =========================
// Read Argo CD server Service
// =========================
// Fetches the Service created by the Argo CD Helm chart.
// This is used to dynamically retrieve service ports
// for Ingress configuration.
data "kubernetes_service" "argo_cd_server" {
  metadata {
    name      = local.argo_cd_server_service_name
    namespace = kubernetes_namespace.argo_cd.metadata[0].name
  }

  depends_on = [helm_release.argo_cd]
}

// =========================
// Argo CD service port resolution
// =========================
// Selects the HTTP port (80) if available.
// Falls back to the first declared service port
// to avoid Terraform apply failures if the chart changes.
locals {
  argo_cd_server_port = try(
    one([
      for p in data.kubernetes_service.argo_cd_server.spec[0].port :
      p.port if p.port == 80
    ]),
    data.kubernetes_service.argo_cd_server.spec[0].port[0].port
  )
}

// =========================
// Argo CD Ingress
// =========================
// Exposes Argo CD UI and API via NGINX Ingress with TLS
// managed by cert-manager and DNS handled by Cloudflare.
resource "kubernetes_ingress_v1" "argo_cd" {
  metadata {
    name      = "argo-cd"
    namespace = kubernetes_namespace.argo_cd.metadata[0].name

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
      host = local.argo_cd_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              // Dynamically resolved Argo CD service + port
              name = data.kubernetes_service.argo_cd_server.metadata[0].name
              port {
                number = local.argo_cd_server_port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.argo_cd_domain_name]
      secret_name = "argo-cd-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.argo_cd,
    helm_release.argo_cd
  ]
}