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
        controller_replica_count = var.argo_cd_controller_replica_count
        controller_request_cpu = var.argo_cd_controller_request_cpu
        controller_request_memory = var.argo_cd_controller_request_memory
        controller_limit_cpu = var.argo_cd_controller_limit_cpu
        controller_limit_memory = var.argo_cd_controller_limit_memory
        application_set_request_cpu = var.argo_cd_application_set_request_cpu
        application_set_request_memory = var.argo_cd_application_set_request_memory
        application_set_limit_cpu = var.argo_cd_application_set_limit_cpu
        application_set_limit_memory = var.argo_cd_application_set_limit_memory
        notifications_request_cpu = var.argo_cd_notifications_request_cpu
        notifications_request_memory = var.argo_cd_notifications_request_memory
        notifications_limit_cpu = var.argo_cd_notifications_limit_cpu
        notifications_limit_memory = var.argo_cd_notifications_limit_memory
        server_request_cpu = var.argo_cd_server_request_cpu
        server_request_memory = var.argo_cd_server_request_memory
        server_limit_cpu = var.argo_cd_server_limit_cpu
        server_limit_memory = var.argo_cd_server_limit_memory
        repo_server_request_cpu = var.argo_cd_repo_server_request_cpu
        repo_server_request_memory = var.argo_cd_repo_server_request_memory
        repo_server_limit_cpu = var.argo_cd_repo_server_limit_cpu
        repo_server_limit_memory = var.argo_cd_repo_server_limit_memory
        redis_host = var.argo_cd_redis_host
        redis_password = var.argo_cd_redis_password
    })
  ]
  depends_on = [
    helm_release.redis_cluster,
    kubernetes_namespace.argo_cd
  ]
}