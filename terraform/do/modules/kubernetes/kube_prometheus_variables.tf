// =========================
// kube-prometheus replica count variables
// =========================
// Number of replicas for each component (default 1).

// Number of kube-prometheus Prometheus server replicas
variable "kube_prometheus_replica_count" {
  type        = number
  description = "Number of kube-prometheus Prometheus server replicas"
  default     = 1
}

// Number of Alertmanager replicas
variable "kube_prometheus_alertmanager_replica_count" {
  type        = number
  description = "Number of Alertmanager replicas"
  default     = 1
}

// Number of Blackbox Exporter replicas
variable "kube_prometheus_blackbox_exporter_replica_count" {
  type        = number
  description = "Number of Blackbox Exporter replicas"
  default     = 1
}

// Number of Thanos Ruler replicas
variable "kube_prometheus_thanos_ruler_replica_count" {
  type        = number
  description = "Number of Thanos Ruler replicas"
  default     = 1
}

// =========================
// kube-prometheus Operator resource variables
// =========================
// Controls resource allocation for the kube-prometheus Operator.

// CPU resource request for the kube-prometheus Operator
variable "kube_prometheus_operator_request_cpu" {
  type        = string
  description = "CPU resource request for the kube-prometheus Operator"
  nullable    = true
  default     = null
}

// Memory resource request for the kube-prometheus Operator
variable "kube_prometheus_operator_request_memory" {
  type        = string
  description = "Memory resource request for the kube-prometheus Operator"
  nullable    = true
  default     = null
}

// CPU resource limit for the kube-prometheus Operator
variable "kube_prometheus_operator_limit_cpu" {
  type        = string
  description = "CPU resource limit for the kube-prometheus Operator"
  nullable    = true
  default     = null
}

// Memory resource limit for the kube-prometheus Operator
variable "kube_prometheus_operator_limit_memory" {
  type        = string
  description = "Memory resource limit for the kube-prometheus Operator"
  nullable    = true
  default     = null
}

// =========================
// kube-prometheus Prometheus resource variables
// =========================
// Controls resource allocation for kube-prometheus Prometheus server.

// CPU resource request for kube-prometheus Prometheus server
variable "kube_prometheus_request_cpu" {
  type        = string
  description = "CPU resource request for kube-prometheus Prometheus server"
  nullable    = true
  default     = null
}

// Memory resource request for kube-prometheus Prometheus server
variable "kube_prometheus_request_memory" {
  type        = string
  description = "Memory resource request for kube-prometheus Prometheus server"
  nullable    = true
  default     = null
}

// CPU resource limit for kube-prometheus Prometheus server
variable "kube_prometheus_limit_cpu" {
  type        = string
  description = "CPU resource limit for kube-prometheus Prometheus server"
  nullable    = true
  default     = null
}

// Memory resource limit for kube-prometheus Prometheus server
variable "kube_prometheus_limit_memory" {
  type        = string
  description = "Memory resource limit for kube-prometheus Prometheus server"
  nullable    = true
  default     = null
}

// Persistent volume size for kube-prometheus Prometheus data
variable "kube_prometheus_persistence_size" {
  type        = string
  description = "Persistent volume size for kube-prometheus Prometheus data"
  default     = "8Gi"
}

// =========================
// Thanos Sidecar resource variables
// =========================
// Controls resource allocation for Thanos sidecar container.

// CPU resource request for Thanos sidecar
variable "kube_prometheus_thanos_request_cpu" {
  type        = string
  description = "CPU resource request for Thanos sidecar"
  nullable    = true
  default     = null
}

// Memory resource request for Thanos sidecar
variable "kube_prometheus_thanos_request_memory" {
  type        = string
  description = "Memory resource request for Thanos sidecar"
  nullable    = true
  default     = null
}

// CPU resource limit for Thanos sidecar
variable "kube_prometheus_thanos_limit_cpu" {
  type        = string
  description = "CPU resource limit for Thanos sidecar"
  nullable    = true
  default     = null
}

// Memory resource limit for Thanos sidecar
variable "kube_prometheus_thanos_limit_memory" {
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
variable "kube_prometheus_alertmanager_request_cpu" {
  type        = string
  description = "CPU resource request for Alertmanager"
  nullable    = true
  default     = null
}

// Memory resource request for Alertmanager
variable "kube_prometheus_alertmanager_request_memory" {
  type        = string
  description = "Memory resource request for Alertmanager"
  nullable    = true
  default     = null
}

// CPU resource limit for Alertmanager
variable "kube_prometheus_alertmanager_limit_cpu" {
  type        = string
  description = "CPU resource limit for Alertmanager"
  nullable    = true
  default     = null
}

// Memory resource limit for Alertmanager
variable "kube_prometheus_alertmanager_limit_memory" {
  type        = string
  description = "Memory resource limit for Alertmanager"
  nullable    = true
  default     = null
}

// Persistent volume size for Alertmanager data
variable "kube_prometheus_alertmanager_persistence_size" {
  type        = string
  description = "Persistent volume size for Alertmanager data"
  default     = "4Gi"
}

// =========================
// Blackbox Exporter resource variables
// =========================
// Controls resource allocation for Blackbox Exporter.

// CPU resource request for Blackbox Exporter
variable "kube_prometheus_blackbox_exporter_request_cpu" {
  type        = string
  description = "CPU resource request for Blackbox Exporter"
  nullable    = true
  default     = null
}

// Memory resource request for Blackbox Exporter
variable "kube_prometheus_blackbox_exporter_request_memory" {
  type        = string
  description = "Memory resource request for Blackbox Exporter"
  nullable    = true
  default     = null
}

// CPU resource limit for Blackbox Exporter
variable "kube_prometheus_blackbox_exporter_limit_cpu" {
  type        = string
  description = "CPU resource limit for Blackbox Exporter"
  nullable    = true
  default     = null
}

// Memory resource limit for Blackbox Exporter
variable "kube_prometheus_blackbox_exporter_limit_memory" {
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
variable "kube_prometheus_thanos_ruler_request_cpu" {
  type        = string
  description = "CPU resource request for Thanos Ruler"
  nullable    = true
  default     = null
}

// Memory resource request for Thanos Ruler
variable "kube_prometheus_thanos_ruler_request_memory" {
  type        = string
  description = "Memory resource request for Thanos Ruler"
  nullable    = true
  default     = null
}

// CPU resource limit for Thanos Ruler
variable "kube_prometheus_thanos_ruler_limit_cpu" {
  type        = string
  description = "CPU resource limit for Thanos Ruler"
  nullable    = true
  default     = null
}

// Memory resource limit for Thanos Ruler
variable "kube_prometheus_thanos_ruler_limit_memory" {
  type        = string
  description = "Memory resource limit for Thanos Ruler"
  nullable    = true
  default     = null
}

// =========================
// Consul metrics scrape (additionalScrapeConfigs)
// =========================
// Two jobs: consul-exporter (sidecar 9107) and consul (HTTP API 8500).
// Requires Consul Helm chart with metrics.enabled = true for exporter.

variable "kube_prometheus_consul_scrape_enabled" {
  type        = bool
  description = "Enable Prometheus additionalScrapeConfigs for Consul (exporter + API)"
  default     = true
}


variable "kube_prometheus_consul_exporter_metrics_path" {
  type        = string
  description = "Consul exporter metrics path"
  default     = "/metrics"
}

variable "kube_prometheus_consul_exporter_scrape_interval" {
  type        = string
  description = "Consul exporter scrape interval"
  default     = "30s"
}

variable "kube_prometheus_consul_metrics_path" {
  type        = string
  description = "Consul metrics path"
  default     = "/api/metrics"
}

variable "kube_prometheus_consul_scrape_interval" {
  type        = string
  description = "Consul API scrape interval"
  default     = "10s"
}

// =========================
// kube-prometheus Basic Auth variables
// =========================
// Controls basic authentication for kube-prometheus ingress.

// HTPASSWD for kube-prometheus basic authentication
variable "kube_prometheus_htpasswd" {
  type        = string
  description = "HTPASSWD for kube-prometheus basic authentication"
  sensitive   = true
}

// HTPASSWD for kube-prometheus Alertmanager basic authentication
variable "kube_prometheus_alertmanager_htpasswd" {
  type        = string
  description = "HTPASSWD for kube-prometheus Alertmanager basic authentication"
  sensitive   = true
}

// HTPASSWD for Kafka UI basic authentication
variable "kafka_ui_htpasswd" {
  type        = string
  description = "HTPASSWD for Kafka UI basic authentication"
  sensitive   = true
}
