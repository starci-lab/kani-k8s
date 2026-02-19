// =========================
// JWT and AES configuration
// =========================
// Configures salts and secrets for JWT and AES encryption.

variable "kani_jwt_salt" {
  type        = string
  description = "Salt value for JWT token generation"
  sensitive   = true
}

variable "kani_aes_cbc_salt" {
  type        = string
  description = "Salt value for AES CBC encryption"
  sensitive   = true
}

// =========================
// Secret mount paths configuration
// =========================
// Defines file system paths where secrets are mounted inside containers.

variable "kani_gcp_crypto_key_ed_sa_mount_path" {
  type        = string
  description = "Mount path for GCP crypto key encryptor/decryptor service account"
  default     = "/etc/terraform/gcp-crypto-key-ed-sa"
}

variable "kani_gcp_cloud_kms_crypto_operator_sa_mount_path" {
  type        = string
  description = "Mount path for Cloud KMS crypto operator service account"
  default     = "/etc/terraform/gcp-cloud-kms-crypto-operator-sa"
}

variable "kani_gcp_google_drive_ud_sa_mount_path" {
  type        = string
  description = "Mount path for Google Drive UD service account"
  default     = "/etc/terraform/gcp-google-drive-ud-sa"
}

variable "kani_encrypted_aes_key_mount_path" {
  type        = string
  description = "Mount path for AES encryption key"
  default     = "/etc/terraform/encrypted-aes-key"
}

variable "kani_encrypted_jwt_secret_key_mount_path" {
  type        = string
  description = "Mount path for JWT secret"
  default     = "/etc/terraform/encrypted-jwt-secret-key"
}

variable "kani_rpcs_mount_path" {
  type        = string
  description = "Mount path for RPCs"
  default     = "/etc/config/rpcs"
}

variable "kani_app_mount_path" {
  type        = string
  description = "Mount path for app"
  default     = "/etc/config/app"
}

variable "kani_privy_app_secret_key_mount_path" {
  type        = string
  description = "Mount path for Privy app secret key"
  default     = "/etc/terraform/privy-app-secret-key"
}

variable "kani_privy_signer_private_key_mount_path" {
  type        = string
  description = "Mount path for Privy signer private key"
  default     = "/etc/terraform/privy-signer-private-key"
}

variable "kani_coin_market_cap_api_key_mount_path" {
  type        = string
  description = "Mount path for Coin Market Cap API key"
  default     = "/etc/terraform/coin-market-cap-api-key"
}

// =========================
// Probes configuration
// =========================
// Defines the probes configuration for the Kani Interface pod.

variable "kani_liveness_probe_path" {
  type        = string
  description = "Path for the liveness probe"
  default     = "/api/terminus/liveness"
}

variable "kani_readiness_probe_path" {
  type        = string
  description = "Path for the readiness probe"
  default     = "/api/terminus/readiness"
}

variable "kani_startup_probe_path" {
  type        = string
  description = "Path for the startup probe"
  default     = "/api/terminus/startup"
}

variable "kani_data_mount_path" {
  type        = string
  description = "Mount path for data"
  default     = "/data"
}

// =========================
// Primary MongoDB configuration
// =========================
// Configures connection to the primary MongoDB database.

variable "kani_primary_mongodb_port" {
  type        = number
  description = "Port number for primary MongoDB database"
  default     = 27017
}

variable "kani_primary_mongodb_database" {
  type        = string
  description = "Database name for primary MongoDB"
  default     = "kani"
}

// =========================
// Kafka configuration
// =========================
// Configures connection to Kafka broker for message queuing.

variable "kani_kafka_broker_port" {
  type        = number
  description = "Port number for Kafka broker"
  default     = 9092
}

variable "kani_kafka_sasl_enabled" {
  type        = string
  description = "Enable SASL authentication for Kafka (true/false)"
  default     = "true"
}

// =========================
// Frontend URL configuration
// =========================
// Configures the frontend URL for the Kani Interface pod.

variable "kani_frontend_url_1" {
  type        = string
  description = "Frontend URL 1"
  default     = "https://kanibot.xyz"
}

variable "kani_frontend_url_2" {
  type        = string
  description = "Frontend URL 2"
  default     = "https://app.kanibot.xyz"
}

// =========================
// Redis Standalone configuration
// =========================
// Configures connection to Redis Standalone for caching and message queuing.

variable "kani_redis_cache_enabled" {
  type        = bool
  description = "Enable Redis cache"
  default     = false
}

variable "kani_redis_adapter_enabled" {
  type        = bool
  description = "Enable Redis adapter"
  default     = false
}

variable "kani_redis_bullmq_enabled" {
  type        = bool
  description = "Enable Redis BullMQ"
  default     = false
}

variable "kani_redis_throttler_enabled" {
  type        = bool
  description = "Enable Redis throttler"
  default     = false
}

variable "kani_redis_lock_authority_enabled" {
  type        = bool
  description = "Enable Redis lock authority"
  default     = false
}

// =========================
// Kubernetes Probe Configuration (Kani)
// =========================

// -------------------------
// Liveness Probe
// -------------------------
// Should be a lightweight endpoint (no Redis/Mongo checks).
variable "kani_liveness_probe_timeout" {
  type        = number
  description = "HTTP timeout (seconds) for the liveness probe"
  default     = 30
}

variable "kani_liveness_probe_initial_delay" {
  type        = number
  description = "Initial delay (seconds) before starting liveness probe"
  default     = 60
}

variable "kani_liveness_probe_period" {
  type        = number
  description = "Period (seconds) between liveness checks"
  default     = 60
}

variable "kani_liveness_probe_failure_threshold" {
  type        = number
  description = "Consecutive failures before restarting the container"
  default     = 3
}

variable "kani_liveness_probe_success_threshold" {
  type        = number
  description = "Consecutive successes required to be considered healthy (usually 1 for liveness)"
  default     = 1
}


// -------------------------
// Readiness Probe
// -------------------------
// May check dependencies (Redis/Mongo/etc.) to decide if the pod should receive traffic.
variable "kani_readiness_probe_timeout" {
  type        = number
  description = "HTTP timeout (seconds) for the readiness probe"
  default     = 30
}

variable "kani_readiness_probe_initial_delay" {
  type        = number
  description = "Initial delay (seconds) before starting readiness probe"
  default     = 60
}

variable "kani_readiness_probe_period" {
  type        = number
  description = "Period (seconds) between readiness checks"
  default     = 60
}

variable "kani_readiness_probe_failure_threshold" {
  type        = number
  description = "Consecutive failures before marking the pod unready"
  default     = 3
}

variable "kani_readiness_probe_success_threshold" {
  type        = number
  description = "Consecutive successes required to be considered ready"
  default     = 1
}


// -------------------------
// Startup Probe
// -------------------------
// Used during application startup; allows longer warm-up without restart loops.
variable "kani_startup_probe_timeout" {
  type        = number
  description = "HTTP timeout (seconds) for the startup probe"
  default     = 30
}

variable "kani_startup_probe_initial_delay" {
  type        = number
  description = "Initial delay (seconds) before starting startup probe"
  default     = 60
}

variable "kani_startup_probe_period" {
  type        = number
  description = "Period (seconds) between startup checks"
  default     = 60
}

variable "kani_startup_probe_failure_threshold" {
  type        = number
  description = "Consecutive failures allowed before startup is considered failed"
  default     = 3
}

variable "kani_startup_probe_success_threshold" {
  type        = number
  description = "Consecutive successes required to be considered started"
  default     = 1
}