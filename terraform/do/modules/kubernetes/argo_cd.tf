// -----------------------------------------------------------------------------
// Namespace
// -----------------------------------------------------------------------------
resource "kubernetes_namespace" "argo_cd" {
  metadata {
    name = "argo-cd"
  }

  // Ensure the cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// -----------------------------------------------------------------------------
// Shared names / IDs
// -----------------------------------------------------------------------------
locals {
  // Argo CD Helm release name
  argo_cd_name = "argo-cd"

  // Service created by the Bitnami Argo CD chart for the UI/API
  argo_cd_server_service_name = "argo-cd-server"
}

// -----------------------------------------------------------------------------
// Redis (external) for Argo CD
// - Installs Bitnami Redis as a separate release
// - Argo CD will be configured to use this Redis instead of the bundled one
// -----------------------------------------------------------------------------
resource "helm_release" "argo_cd_redis" {
  name      = "argo-cd-redis"
  namespace = kubernetes_namespace.argo_cd.metadata[0].name
  chart     = "oci://registry-1.docker.io/bitnamicharts/redis"

  // Render Redis Helm values from a template file
  values = [
    templatefile("${path.module}/yamls/redis.yaml", {
      password        = var.argo_cd_redis_password
      request_cpu     = local.argocd.redis.request_cpu
      request_memory  = local.argocd.redis.request_memory
      limit_cpu       = local.argocd.redis.limit_cpu
      limit_memory    = local.argocd.redis.limit_memory
    })
  ]

  depends_on = [
    kubernetes_namespace.argo_cd
  ]
}

// Discover the Redis "master" Service name (use DNS name, not ClusterIP)
data "kubernetes_service" "argo_cd_redis" {
  metadata {
    // NOTE: This name must match what the Redis chart actually creates.
    // Common patterns: "<release>-master" for replication/standalone variants.
    name      = "argo-cd-redis-master"
    namespace = kubernetes_namespace.argo_cd.metadata[0].name
  }

  depends_on = [
    helm_release.argo_cd_redis
  ]
}

// -----------------------------------------------------------------------------
// Argo CD
// - Installs Bitnami Argo CD
// - Uses external Redis deployed above
// -----------------------------------------------------------------------------
resource "helm_release" "argo_cd" {
  name      = local.argo_cd_name
  namespace = kubernetes_namespace.argo_cd.metadata[0].name
  chart     = "oci://registry-1.docker.io/bitnamicharts/argo-cd"

  // Render Argo CD Helm values from a template file
  values = [
    templatefile("${path.module}/yamls/argo-cd.yaml", {
      // Admin authentication
      admin_password = var.argo_cd_admin_password

      // Application controller
      controller_replica_count  = var.argo_cd_controller_replica_count
      controller_request_cpu    = local.argocd.controller.request_cpu
      controller_request_memory = local.argocd.controller.request_memory
      controller_limit_cpu      = local.argocd.controller.limit_cpu
      controller_limit_memory   = local.argocd.controller.limit_memory

      // ApplicationSet controller
      application_set_request_cpu    = local.argocd.application_set.request_cpu
      application_set_request_memory = local.argocd.application_set.request_memory
      application_set_limit_cpu      = local.argocd.application_set.limit_cpu
      application_set_limit_memory   = local.argocd.application_set.limit_memory

      // Notifications controller
      notifications_request_cpu    = local.argocd.notifications.request_cpu
      notifications_request_memory = local.argocd.notifications.request_memory
      notifications_limit_cpu      = local.argocd.notifications.limit_cpu
      notifications_limit_memory   = local.argocd.notifications.limit_memory

      // API/UI server
      server_request_cpu    = local.argocd.server.request_cpu
      server_request_memory = local.argocd.server.request_memory
      server_limit_cpu      = local.argocd.server.limit_cpu
      server_limit_memory   = local.argocd.server.limit_memory

      // Repo-server
      repo_server_request_cpu    = local.argocd.repo_server.request_cpu
      repo_server_request_memory = local.argocd.repo_server.request_memory
      repo_server_limit_cpu      = local.argocd.repo_server.limit_cpu
      repo_server_limit_memory   = local.argocd.repo_server.limit_memory

      // External Redis endpoint (use Service DNS name)
      redis_host     = data.kubernetes_service.argo_cd_redis.metadata[0].name
      redis_password = var.argo_cd_redis_password
    })
  ]

  depends_on = [
    helm_release.argo_cd_redis,
    kubernetes_namespace.argo_cd
  ]
}

// -----------------------------------------------------------------------------
// Read Argo CD server Service (for Ingress wiring)
// -----------------------------------------------------------------------------
data "kubernetes_service" "argo_cd_server" {
  metadata {
    name      = local.argo_cd_server_service_name
    namespace = kubernetes_namespace.argo_cd.metadata[0].name
  }

  depends_on = [helm_release.argo_cd]
}

// Pick port 80 if present; otherwise use the first declared service port
locals {
  argo_cd_server_port = try(
    one([
      for p in data.kubernetes_service.argo_cd_server.spec[0].port :
      p.port if p.port == 80
    ]),
    data.kubernetes_service.argo_cd_server.spec[0].port[0].port
  )
}

// -----------------------------------------------------------------------------
// Ingress (NGINX + cert-manager TLS)
// -----------------------------------------------------------------------------
resource "kubernetes_ingress_v1" "argo_cd" {
  metadata {
    name      = "argo-cd"
    namespace = kubernetes_namespace.argo_cd.metadata[0].name

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
      host = local.argo_cd_domain_name

      http {
        path {
          path = "/"

          backend {
            service {
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
