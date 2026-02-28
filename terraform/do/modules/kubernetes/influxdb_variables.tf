// =========================
// InfluxDB configuration
// =========================
// Variables for Bitnami InfluxDB Helm chart (loki-monilithic-style template).

// Number of InfluxDB replicas
variable "influxdb_replica_count" {
  type        = number
  description = "Number of InfluxDB replicas"
  default     = 1
}

// =========================
// InfluxDB resources
// =========================
// CPU and memory requests/limits; null = use preset from resources_config.

// CPU resource request for InfluxDB
variable "influxdb_request_cpu" {
  type        = string
  description = "CPU resource request for InfluxDB"
  nullable    = true
  default     = null
}

// Memory resource request for InfluxDB
variable "influxdb_request_memory" {
  type        = string
  description = "Memory resource request for InfluxDB"
  nullable    = true
  default     = null
}

// CPU resource limit for InfluxDB
variable "influxdb_limit_cpu" {
  type        = string
  description = "CPU resource limit for InfluxDB"
  nullable    = true
  default     = null
}

// Memory resource limit for InfluxDB
variable "influxdb_limit_memory" {
  type        = string
  description = "Memory resource limit for InfluxDB"
  nullable    = true
  default     = null
}

// =========================
// InfluxDB persistence
// =========================
// Persistent volume size when objectStore is file.

variable "influxdb_persistence_size" {
  type        = string
  description = "Persistent volume size for InfluxDB data"
  default     = "8Gi"
}
