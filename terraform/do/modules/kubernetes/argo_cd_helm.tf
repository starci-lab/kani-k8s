// =========================
// NOTE: This file is currently disabled (commented out)
// =========================
// The Helm releases in this file are commented out and not active.
// Uncomment when ready to deploy Argo CD via Helm.

// =========================
// Argo CD local identifiers
// =========================
// Local values for Argo CD component names and service identifiers.
# locals {
#   // Argo CD Helm release name
#   argo_cd_name = "argo-cd"
#
#   // Service created by the Bitnami Argo CD chart for the UI/API
#   argo_cd_server_service_name = "argo-cd-server"
# }

// =========================
// Argo CD Redis (external)
// =========================
// Deploys Bitnami Redis for Argo CD caching and session storage.
// Argo CD is configured to use this external Redis instead of the bundled Redis.
# resource "helm_release" "argo_cd_redis" {
#   name      = "argo-cd-redis"
#   namespace = kubernetes_namespace.argo_cd.metadata[0].name
#   chart     = "oci://registry-1.docker.io/bitnamicharts/redis"
#
#   // Render Redis Helm values from a template file
#   values = [
#     templatefile("${path.module}/yamls/redis.yaml", {
#       password                = var.argo_cd_redis_password
#       replica_replica_count   = var.argo_cd_redis_replica_count
#       master_request_cpu      = local.argocd.redis.request_cpu
#       master_request_memory   = local.argocd.redis.request_memory
#       master_limit_cpu        = local.argocd.redis.limit_cpu
#       master_limit_memory     = local.argocd.redis.limit_memory
#       master_persistence_size = var.argo_cd_redis_master_persistence_size
#       replica_request_cpu     = local.argocd.redis.request_cpu
#       replica_request_memory  = local.argocd.redis.request_memory
#       replica_limit_cpu       = local.argocd.redis.limit_cpu
#       replica_limit_memory    = local.argocd.redis.limit_memory
#       replica_persistence_size = var.argo_cd_redis_replica_persistence_size
#     })
#   ]
#
#   depends_on = [
#     kubernetes_namespace.argo_cd
#   ]
# }

// =========================
// Argo CD Helm release
// =========================
// Deploys Argo CD using the Bitnami Helm chart.
// Argo CD automates the deployment and lifecycle management of Kubernetes applications.
// Resource requests and limits for each Argo CD component are configured via a templated values file.
# resource "helm_release" "argo_cd" {
#   name      = local.argo_cd_name
#   namespace = kubernetes_namespace.argo_cd.metadata[0].name
#   chart     = "oci://registry-1.docker.io/bitnamicharts/argo-cd"
#
#   // Render Argo CD Helm values from a template file
#   values = [
#     templatefile("${path.module}/yamls/argo-cd.yaml", {
#       // Admin authentication
#       admin_password = var.argo_cd_admin_password
#
#       // Application controller
#       controller_replica_count  = var.argo_cd_controller_replica_count
#       application_set_replica_count = var.argo_cd_application_set_replica_count
#       server_replica_count      = var.argo_cd_server_replica_count
#       repo_server_replica_count = var.argo_cd_repo_server_replica_count
#       controller_request_cpu    = local.argocd.controller.request_cpu
#       controller_request_memory = local.argocd.controller.request_memory
#       controller_limit_cpu      = local.argocd.controller.limit_cpu
#       controller_limit_memory   = local.argocd.controller.limit_memory
#
#       // ApplicationSet controller
#       application_set_request_cpu    = local.argocd.application_set.request_cpu
#       application_set_request_memory = local.argocd.application_set.request_memory
#       application_set_limit_cpu      = local.argocd.application_set.limit_cpu
#       application_set_limit_memory   = local.argocd.application_set.limit_memory
#
#       // Notifications controller
#       notifications_request_cpu    = local.argocd.notifications.request_cpu
#       notifications_request_memory = local.argocd.notifications.request_memory
#       notifications_limit_cpu      = local.argocd.notifications.limit_cpu
#       notifications_limit_memory   = local.argocd.notifications.limit_memory
#
#       // API/UI server
#       server_request_cpu    = local.argocd.server.request_cpu
#       server_request_memory = local.argocd.server.request_memory
#       server_limit_cpu      = local.argocd.server.limit_cpu
#       server_limit_memory   = local.argocd.server.limit_memory
#
#       // Repo-server
#       repo_server_request_cpu    = local.argocd.repo_server.request_cpu
#       repo_server_request_memory = local.argocd.repo_server.request_memory
#       repo_server_limit_cpu      = local.argocd.repo_server.limit_cpu
#       repo_server_limit_memory   = local.argocd.repo_server.limit_memory
#
#       // External Redis endpoint (use Service DNS name)
#       redis_host     = data.kubernetes_service.argo_cd_redis.metadata[0].name
#       redis_password = var.argo_cd_redis_password
#     })
#   ]
#
#   depends_on = [
#     helm_release.argo_cd_redis,
#     kubernetes_namespace.argo_cd
#   ]
# }
