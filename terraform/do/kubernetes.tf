module "kubernetes" {
  source = "./modules/kubernetes"
  kubernetes_name = var.kubernetes_name
  kubernetes_region = var.kubernetes_region
  kubernetes_version = var.kubernetes_version
  kubernetes_node_pool_name = var.kubernetes_node_pool_name
  kubernetes_node_pool_size = var.kubernetes_node_pool_size
  kubernetes_node_pool_node_count = var.kubernetes_node_pool_node_count
  mongodb_root_password = var.mongodb_root_password
  redis_password = var.redis_password
  argo_cd_admin_password = var.argo_cd_admin_password
  argo_cd_redis_password = var.redis_password
}