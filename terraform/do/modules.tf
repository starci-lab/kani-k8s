// ======================================================
// Kubernetes platform module
// ======================================================
// This module is responsible for provisioning:
// - DigitalOcean Kubernetes cluster (DOKS)
// - Core platform services (MongoDB, Redis, Kafka)
// - Platform tooling (Argo CD, Ingress, DNS)
// ======================================================

module "kubernetes" {
  source = "./modules/kubernetes"
  // ==================================================
  // Kubernetes cluster configuration (DOKS)
  // ==================================================
  // Cluster name
  kubernetes_name = var.kubernetes_name
  // DigitalOcean region (e.g. sgp1, fra1)
  kubernetes_region = var.kubernetes_region
  // Kubernetes version (e.g. 1.29.x-do.0)
  kubernetes_version = var.kubernetes_version
  // Primary node pool configuration
  kubernetes_primary_node_pool_name       = var.kubernetes_primary_node_pool_name
  kubernetes_primary_node_pool_size       = var.kubernetes_primary_node_pool_size
  kubernetes_primary_node_pool_node_count = var.kubernetes_primary_node_pool_node_count
  // ==================================================
  // MongoDB Sharded configuration
  // ==================================================
  // Root user credentials for MongoDB Sharded cluster
  mongodb_root_username = var.mongodb_root_user
  mongodb_root_password = var.mongodb_root_password
  // ==================================================
  // Redis configuration
  // ==================================================
  // Password for Redis (used by Redis Cluster and Argo CD Redis)
  redis_password = var.redis_password

  // Enable / disable Redis Cluster deployment
  enable_redis_cluster = var.enable_redis_cluster
  // ==================================================
  // Argo CD configuration
  // ==================================================
  // Admin password for Argo CD (bcrypt-hashed)
  argo_cd_admin_password = var.argo_cd_admin_password
  // Redis password used by Argo CD (external Redis)
  argo_cd_redis_password = var.redis_password
  // ==================================================
  // Kafka configuration
  // ==================================================
  // SASL password for Kafka authentication
  kafka_sasl_password = var.kafka_sasl_password
  // ==================================================
  // DNS / Domain configuration
  // ==================================================
  // Base domain name (used for Argo CD, Prometheus, API, etc.)
  domain_name = var.domain_name
}