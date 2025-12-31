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

// =========================
// Prometheus basic authentication variables
// =========================

variable "prometheus_htpasswd" {
  type        = string
  description = "HTPASSWD for Prometheus basic authentication"
  sensitive   = true
}

variable "prometheus_alertmanager_basic_auth_username" {
  type        = string
  description = "Username for Prometheus Alertmanager basic authentication"
  default     = "kani"
}

variable "prometheus_alertmanager_basic_auth_password" {
  type        = string
  description = "Password for Prometheus Alertmanager basic authentication"
  sensitive   = true
}

variable "prometheus_alertmanager_htpasswd" {
  type        = string
  description = "HTPASSWD for Prometheus Alertmanager basic authentication"
  sensitive   = true
}

variable "prometheus_basic_auth_username" {
  type        = string
  description = "Username for Prometheus basic authentication"
  default     = "kani"
}

variable "prometheus_basic_auth_password" {
  type        = string
  description = "Password for Prometheus basic authentication"
  sensitive   = true
}

variable "kafka_ui_htpasswd" {
  type        = string
  description = "HTPASSWD for Kafka UI basic authentication"
  sensitive   = true
}

// =========================
// Grafana basic authentication variables
// =========================

variable "grafana_user" {
  type        = string
  description = "Username for Grafana basic authentication"
  default     = "kani"
}

variable "grafana_password" {
  type        = string
  description = "Password for Grafana basic authentication"
  sensitive   = true
}