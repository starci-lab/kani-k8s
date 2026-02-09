// =========================
// Grafana admin credentials
// =========================
// Controls authentication for Grafana admin user.

variable "grafana_user" {
  type        = string
  description = "Username for Grafana admin user"
}

variable "grafana_password" {
  type        = string
  description = "Password for Grafana admin user"
  sensitive   = true
}

variable "grafana_replica_count" {
  type        = number
  description = "Number of Grafana server replicas"
  default     = 1
}

// =========================
// Grafana resource variables
// =========================
// Controls resource allocation for Grafana server.

variable "grafana_request_cpu" {
  type        = string
  description = "CPU resource request for Grafana server"
  nullable    = true
  default     = null
}

variable "grafana_request_memory" {
  type        = string
  description = "Memory resource request for Grafana server"
  nullable    = true
  default     = null
}

variable "grafana_limit_cpu" {
  type        = string
  description = "CPU resource limit for Grafana server"
  nullable    = true
  default     = null
}

variable "grafana_limit_memory" {
  type        = string
  description = "Memory resource limit for Grafana server"
  nullable    = true
  default     = null
}

// =========================
// Grafana persistence variables
// =========================
// Defines persistent storage size for Grafana data to ensure
// durability across pod restarts.

variable "grafana_persistence_size" {
  type        = string
  description = "Persistent volume size for Grafana data"
  default     = "2Gi"
}

// =========================
// Prometheus datasource configuration
// =========================
// Configures Prometheus as a data source in Grafana.

variable "prometheus_url" {
  type        = string
  description = "URL for Prometheus instance (used as Grafana data source)"
  default     = "https://prometheus.kanibot.xyz"
}

variable "prometheus_basic_auth_user" {
  type        = string
  description = "Username for Prometheus basic authentication"
}

variable "prometheus_basic_auth_password" {
  type        = string
  description = "Password for Prometheus basic authentication"
  sensitive   = true
}

// =========================
// Alertmanager datasource configuration
// =========================
// Configures Alertmanager as a data source in Grafana.

variable "prometheus_alertmanager_url" {
  type        = string
  description = "URL for Alertmanager instance (used as Grafana data source)"
  default     = "https://prometheus-alertmanager.kanibot.xyz"
}

variable "prometheus_alertmanager_basic_auth_user" {
  type        = string
  description = "Username for Alertmanager basic authentication"
}

variable "prometheus_alertmanager_basic_auth_password" {
  type        = string
  description = "Password for Alertmanager basic authentication"
  sensitive   = true
}

// =========================
// Loki basic authentication variables
// =========================
variable "loki_url" {
  type        = string
  description = "URL for Loki instance (used as Grafana data source)"
  default     = "https://loki-gateway.kanibot.xyz"
}

variable "loki_basic_auth_user" {
  type        = string
  description = "User for Loki basic authentication"
  sensitive   = true
}

variable "loki_basic_auth_password" {
  type        = string
  description = "Password for Loki basic authentication"
  sensitive   = true
}