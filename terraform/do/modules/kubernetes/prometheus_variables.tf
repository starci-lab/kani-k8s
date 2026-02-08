// =========================
// Prometheus replica count variables
// =========================
// Number of replicas for each component (default 1).

// Number of Prometheus server replicas
variable "prometheus_replica_count" {
  type        = number
  description = "Number of Prometheus server replicas"
  default     = 1
}

// Number of Alertmanager replicas
variable "alertmanager_replica_count" {
  type        = number
  description = "Number of Alertmanager replicas"
  default     = 1
}

// Number of Blackbox Exporter replicas
variable "blackbox_exporter_replica_count" {
  type        = number
  description = "Number of Blackbox Exporter replicas"
  default     = 1
}

// Number of Thanos Ruler replicas
variable "thanos_ruler_replica_count" {
  type        = number
  description = "Number of Thanos Ruler replicas"
  default     = 1
}

// =========================
// Prometheus Operator resource variables
// =========================
// Controls resource allocation for the Prometheus Operator.

// CPU resource request for the Prometheus Operator
variable "operator_request_cpu" {
  type        = string
  description = "CPU resource request for the Prometheus Operator"
  nullable    = true
  default     = null
}

// Memory resource request for the Prometheus Operator
variable "operator_request_memory" {
  type        = string
  description = "Memory resource request for the Prometheus Operator"
  nullable    = true
  default     = null
}

// CPU resource limit for the Prometheus Operator
variable "operator_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Prometheus Operator"
  nullable    = true
  default     = null
}

// Memory resource limit for the Prometheus Operator
variable "operator_limit_memory" {
  type        = string
  description = "Memory resource limit for the Prometheus Operator"
  nullable    = true
  default     = null
}

// =========================
// Prometheus resource variables
// =========================
// Controls resource allocation for Prometheus server.

// CPU resource request for Prometheus server
variable "prometheus_request_cpu" {
  type        = string
  description = "CPU resource request for Prometheus server"
  nullable    = true
  default     = null
}

// Memory resource request for Prometheus server
variable "prometheus_request_memory" {
  type        = string
  description = "Memory resource request for Prometheus server"
  nullable    = true
  default     = null
}

// CPU resource limit for Prometheus server
variable "prometheus_limit_cpu" {
  type        = string
  description = "CPU resource limit for Prometheus server"
  nullable    = true
  default     = null
}

// Memory resource limit for Prometheus server
variable "prometheus_limit_memory" {
  type        = string
  description = "Memory resource limit for Prometheus server"
  nullable    = true
  default     = null
}

// Persistent volume size for Prometheus data
variable "prometheus_persistence_size" {
  type        = string
  description = "Persistent volume size for Prometheus data"
  default     = "2Gi"
}

// =========================
// Thanos Sidecar resource variables
// =========================
// Controls resource allocation for Thanos sidecar container.

// CPU resource request for Thanos sidecar
variable "thanos_request_cpu" {
  type        = string
  description = "CPU resource request for Thanos sidecar"
  nullable    = true
  default     = null
}

// Memory resource request for Thanos sidecar
variable "thanos_request_memory" {
  type        = string
  description = "Memory resource request for Thanos sidecar"
  nullable    = true
  default     = null
}

// CPU resource limit for Thanos sidecar
variable "thanos_limit_cpu" {
  type        = string
  description = "CPU resource limit for Thanos sidecar"
  nullable    = true
  default     = null
}

// Memory resource limit for Thanos sidecar
variable "thanos_limit_memory" {
  type        = string
  description = "Memory resource limit for Thanos sidecar"
  nullable    = true
  default     = null
}

// =========================
// Alertmanager resource variables
// =========================
// Controls resource allocation for Alertmanager.

// CPU resource request for Alertmanager
variable "alertmanager_request_cpu" {
  type        = string
  description = "CPU resource request for Alertmanager"
  nullable    = true
  default     = null
}

// Memory resource request for Alertmanager
variable "alertmanager_request_memory" {
  type        = string
  description = "Memory resource request for Alertmanager"
  nullable    = true
  default     = null
}

// CPU resource limit for Alertmanager
variable "alertmanager_limit_cpu" {
  type        = string
  description = "CPU resource limit for Alertmanager"
  nullable    = true
  default     = null
}

// Memory resource limit for Alertmanager
variable "alertmanager_limit_memory" {
  type        = string
  description = "Memory resource limit for Alertmanager"
  nullable    = true
  default     = null
}

// Persistent volume size for Alertmanager data
variable "alertmanager_persistence_size" {
  type        = string
  description = "Persistent volume size for Alertmanager data"
  default     = "2Gi"
}

// =========================
// Blackbox Exporter resource variables
// =========================
// Controls resource allocation for Blackbox Exporter.

// CPU resource request for Blackbox Exporter
variable "blackbox_exporter_request_cpu" {
  type        = string
  description = "CPU resource request for Blackbox Exporter"
  nullable    = true
  default     = null
}

// Memory resource request for Blackbox Exporter
variable "blackbox_exporter_request_memory" {
  type        = string
  description = "Memory resource request for Blackbox Exporter"
  nullable    = true
  default     = null
}

// CPU resource limit for Blackbox Exporter
variable "blackbox_exporter_limit_cpu" {
  type        = string
  description = "CPU resource limit for Blackbox Exporter"
  nullable    = true
  default     = null
}

// Memory resource limit for Blackbox Exporter
variable "blackbox_exporter_limit_memory" {
  type        = string
  description = "Memory resource limit for Blackbox Exporter"
  nullable    = true
  default     = null
}

// =========================
// Thanos Ruler resource variables
// =========================
// Controls resource allocation for Thanos Ruler.

// CPU resource request for Thanos Ruler
variable "thanos_ruler_request_cpu" {
  type        = string
  description = "CPU resource request for Thanos Ruler"
  nullable    = true
  default     = null
}

// Memory resource request for Thanos Ruler
variable "thanos_ruler_request_memory" {
  type        = string
  description = "Memory resource request for Thanos Ruler"
  nullable    = true
  default     = null
}

// CPU resource limit for Thanos Ruler
variable "thanos_ruler_limit_cpu" {
  type        = string
  description = "CPU resource limit for Thanos Ruler"
  nullable    = true
  default     = null
}

// Memory resource limit for Thanos Ruler
variable "thanos_ruler_limit_memory" {
  type        = string
  description = "Memory resource limit for Thanos Ruler"
  nullable    = true
  default     = null
}

// =========================
// Prometheus Basic Auth variables
// =========================
// Controls basic authentication for Prometheus ingress.

// HTPASSWD for Prometheus basic authentication
variable "prometheus_htpasswd" {
  type        = string
  description = "HTPASSWD for Prometheus basic authentication"
  sensitive   = true
}

// HTPASSWD for Prometheus Alertmanager basic authentication
variable "prometheus_alertmanager_htpasswd" {
  type        = string
  description = "HTPASSWD for Prometheus Alertmanager basic authentication"
  sensitive   = true
}

// HTPASSWD for Kafka UI basic authentication
variable "kafka_ui_htpasswd" {
  type        = string
  description = "HTPASSWD for Kafka UI basic authentication"
  sensitive   = true
}
