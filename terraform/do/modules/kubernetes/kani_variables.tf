// =========================
// GCP KMS configuration
// =========================
// Configures Google Cloud KMS key for encryption operations.
variable "kani_gcp_kms_key_name" {
  type        = string
  description = "GCP KMS key name for encryption/decryption operations"
  sensitive = true
}

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
  default     = "/etc/crypto-key-ed-sa"
}

variable "kani_aes_mount_path" {
  type        = string
  description = "Mount path for AES encryption key"
  default     = "/etc/secrets/aes"
}

variable "kani_jwt_secret_mount_path" {
  type        = string
  description = "Mount path for JWT secret"
  default     = "/etc/secrets/jwt"
}

variable "kani_stmp_mount_path" {
  type        = string
  description = "Mount path for SMTP configuration"
  default     = "/etc/secrets/smtp"
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
