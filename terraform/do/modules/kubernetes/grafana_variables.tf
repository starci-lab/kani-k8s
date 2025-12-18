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

variable "prometheus_basic_auth_username" {
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

variable "prometheus_alertmanager_basic_auth_username" {
  type        = string
  description = "Username for Alertmanager basic authentication"
}

variable "prometheus_alertmanager_basic_auth_password" {
  type        = string
  description = "Password for Alertmanager basic authentication"
  sensitive   = true
}

locals {
  grafana_presets = {
    grafana = "16"
  }
}

locals {
  grafana = {
    grafana = {
      request_cpu = coalesce(
        var.grafana_request_cpu,
        try(var.resources_config[local.grafana_presets.grafana].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.grafana_request_memory,
        try(var.resources_config[local.grafana_presets.grafana].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.grafana_limit_cpu,
        try(var.resources_config[local.grafana_presets.grafana].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.grafana_limit_memory,
        try(var.resources_config[local.grafana_presets.grafana].limits.memory, "256Mi")
      )
    }
  }
}
