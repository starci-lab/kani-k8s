// =========================
// Kafka authentication (SASL) variables
// =========================

variable "kafka_sasl_user" {
  type        = string
  description = "SASL authentication username used by Kafka clients to authenticate and connect to the Kafka cluster"
  default     = "kani"
}

variable "kafka_sasl_password" {
  type        = string
  description = "SASL authentication password for the Kafka user; must be supplied securely (e.g., via tfvars, environment variables, or a secrets manager)"
  sensitive   = true
}

// =========================
// MongoDB authentication variables
// =========================

variable "mongodb_root_user" {
  type        = string
  description = "MongoDB administrative (root) username with full cluster-wide privileges, used for initial setup and administration"
  default     = "kani"
}

variable "mongodb_root_password" {
  type        = string
  description = "Password for the MongoDB administrative (root) user; must be provided securely (e.g., via tfvars, environment variables, or a secrets manager)"
  sensitive   = true
}

variable "mongodb_database" {
  type        = string
  description = "Name of the primary MongoDB database created during initialization and used by the application"
  default     = "kani"
}

// =========================
// Redis authentication variables
// =========================

variable "redis_password" {
  type        = string
  description = "Authentication password required for clients to connect to Redis; must be supplied securely (e.g., via tfvars, environment variables, or a secrets manager)"
  sensitive   = true
}

// =========================
// Argo CD authentication variables
// =========================
variable "argo_cd_admin_password" {
  type        = string
  description = "Administrative password for Argo CD; must be provided securely (e.g., via tfvars, environment variables, or a secrets manager)"
  sensitive   = true
}