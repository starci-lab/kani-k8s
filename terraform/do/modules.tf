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
  // Root password for MongoDB Sharded cluster
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
  // ==================================================
  // Prometheus configuration
  // ==================================================
  // Htpasswd for Prometheus basic authentication
  prometheus_htpasswd = var.prometheus_htpasswd
  prometheus_alertmanager_htpasswd = var.prometheus_alertmanager_htpasswd
  // ==================================================
  // Grafana configuration
  // ==================================================
  // Grafana user
  grafana_user = var.grafana_user
  // Grafana password
  grafana_password = var.grafana_password
  // Prometheus Alertmanager basic authentication username
  prometheus_alertmanager_basic_auth_username = var.prometheus_alertmanager_basic_auth_username
  // Prometheus Alertmanager basic authentication password
  prometheus_alertmanager_basic_auth_password = var.prometheus_alertmanager_basic_auth_password
  // Prometheus basic authentication username
  prometheus_basic_auth_username = var.prometheus_basic_auth_username
  // Prometheus basic authentication password
  prometheus_basic_auth_password = var.prometheus_basic_auth_password
  // Argo CD Git repository URL
  argo_cd_git_ssh_private_key = var.argo_cd_git_ssh_private_key
  // GCP project ID
  gcp_project_id = var.gcp_project_id
  // GCP KMS key name
  kani_gcp_kms_key_name = var.gcp_kms_key_name
  // JWT salt
  kani_jwt_salt = var.jwt_salt
  // AES CBC salt
  kani_aes_cbc_salt = var.aes_cbc_salt
  // Jenkins user
  jenkins_user = var.jenkins_user
  // Jenkins password
  jenkins_password = var.jenkins_password
  // Kani Interface Deployment Rollout Webhook Token
  kani_interface_deployment_rollout_webhook_token = var.kani_interface_deployment_rollout_webhook_token
  // Kani Coordinator Deployment Rollout Webhook Token
  kani_coordinator_deployment_rollout_webhook_token = var.kani_coordinator_deployment_rollout_webhook_token
  // Kani Observer Deployment Rollout Webhook Token
  kani_observer_deployment_rollout_webhook_token = var.kani_observer_deployment_rollout_webhook_token
  // Kafka UI basic authentication htpasswd
  kafka_ui_htpasswd = var.kafka_ui_htpasswd
}

// ======================================================
// Argo CD module
// ======================================================
// This module is responsible for provisioning:
// - Argo CD
// - Argo CD Applications
// - Argo CD Projects
// ======================================================