# Namespace for Argo CD
resource "kubernetes_namespace" "argo_cd" {
  metadata {
    name = "argo-cd"
  }
  depends_on = [ digitalocean_kubernetes_cluster.kubernetes ]
}

# Argo CD
resource "helm_release" "argo_cd" {
  name             = "argo-cd"
  namespace        = kubernetes_namespace.argo_cd.metadata[0].name
  chart = "oci://registry-1.docker.io/bitnamicharts/argo-cd"
  values = [
    templatefile(
      "${path.module}/yamls/argo-cd.yaml", {
        admin_password = var.argo_cd_admin_password
        controller_replica_count = var.controller_replica_count
        controller_request_cpu = var.controller_request_cpu
        controller_request_memory = var.controller_request_memory
        controller_limit_cpu = var.controller_limit_cpu
        controller_limit_memory = var.controller_limit_memory
        application_set_request_cpu = var.application_set_request_cpu
        application_set_request_memory = var.application_set_request_memory
        application_set_limit_cpu = var.application_set_limit_cpu
        application_set_limit_memory = var.application_set_limit_memory
        notifications_request_cpu = var.notifications_request_cpu
        notifications_request_memory = var.notifications_request_memory
        notifications_limit_cpu = var.notifications_limit_cpu
        notifications_limit_memory = var.notifications_limit_memory
        server_request_cpu = var.server_request_cpu
        server_request_memory = var.server_request_memory
        server_limit_cpu = var.server_limit_cpu
        server_limit_memory = var.server_limit_memory
        repo_server_request_cpu = var.repo_server_request_cpu
        repo_server_request_memory = var.repo_server_request_memory
        repo_server_limit_cpu = var.repo_server_limit_cpu
        repo_server_limit_memory = var.repo_server_limit_memory
        redis_host = var.argo_cd_redis_host
        redis_password = var.argo_cd_redis_password
    })
  ]
  depends_on = [
    helm_release.redis_cluster,
    kubernetes_namespace.argo_cd
  ]
}