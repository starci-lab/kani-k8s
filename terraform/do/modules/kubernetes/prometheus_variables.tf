// =========================
// Prometheus Operator resource variables
// =========================
// Controls resource allocation for the Prometheus Operator.

variable "operator_request_cpu" {
  type        = string
  description = "CPU resource request for the Prometheus Operator"
  default     = "32m"
}

variable "operator_request_memory" {
  type        = string
  description = "Memory resource request for the Prometheus Operator"
  default     = "64Mi"
}

variable "operator_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Prometheus Operator"
  default     = "128m"
}

variable "operator_limit_memory" {
  type        = string
  description = "Memory resource limit for the Prometheus Operator"
  default     = "512Mi"
}

// =========================
// Prometheus resource variables
// =========================
// Controls resource allocation for Prometheus server.

variable "prometheus_request_cpu" {
  type        = string
  description = "CPU resource request for Prometheus server"
  default     = "64m"
}

variable "prometheus_request_memory" {
  type        = string
  description = "Memory resource request for Prometheus server"
  default     = "128Mi"
}

variable "prometheus_limit_cpu" {
  type        = string
  description = "CPU resource limit for Prometheus server"
  default     = "128m"
}

variable "prometheus_limit_memory" {
  type        = string
  description = "Memory resource limit for Prometheus server"
  default     = "512Mi"
}

variable "prometheus_persistence_size" {
  type        = string
  description = "Persistent volume size for Prometheus data"
  default     = "2Gi"
}

// =========================
// Thanos Sidecar resource variables
// =========================
// Controls resource allocation for Thanos sidecar container.

variable "thanos_request_cpu" {
  type        = string
  description = "CPU resource request for Thanos sidecar"
  default     = "32m"
}

variable "thanos_request_memory" {
  type        = string
  description = "Memory resource request for Thanos sidecar"
  default     = "64Mi"
}

variable "thanos_limit_cpu" {
  type        = string
  description = "CPU resource limit for Thanos sidecar"
  default     = "128m"
}

variable "thanos_limit_memory" {
  type        = string
  description = "Memory resource limit for Thanos sidecar"
  default     = "256Mi"
}

// =========================
// Alertmanager resource variables
// =========================
// Controls resource allocation for Alertmanager.

variable "alertmanager_request_cpu" {
  type        = string
  description = "CPU resource request for Alertmanager"
  default     = "32m"
}

variable "alertmanager_request_memory" {
  type        = string
  description = "Memory resource request for Alertmanager"
  default     = "64Mi"
}

variable "alertmanager_limit_cpu" {
  type        = string
  description = "CPU resource limit for Alertmanager"
  default     = "128m"
}

variable "alertmanager_limit_memory" {
  type        = string
  description = "Memory resource limit for Alertmanager"
  default     = "256Mi"
}

variable "alertmanager_persistence_size" {
  type        = string
  description = "Persistent volume size for Alertmanager data"
  default     = "2Gi"
}


// =========================
// Blackbox Exporter resource variables
// =========================
// Controls resource allocation for Blackbox Exporter.

variable "blackbox_exporter_request_cpu" {
  type        = string
  description = "CPU resource request for Blackbox Exporter"
  default     = "16m"
}

variable "blackbox_exporter_request_memory" {
  type        = string
  description = "Memory resource request for Blackbox Exporter"
  default     = "32Mi"
}

variable "blackbox_exporter_limit_cpu" {
  type        = string
  description = "CPU resource limit for Blackbox Exporter"
  default     = "64m"
}

variable "blackbox_exporter_limit_memory" {
  type        = string
  description = "Memory resource limit for Blackbox Exporter"
  default     = "128Mi"
}

// =========================
// Thanos Ruler resource variables
// =========================
// Controls resource allocation for Thanos Ruler.

variable "thanos_ruler_request_cpu" {
  type        = string
  description = "CPU resource request for Thanos Ruler"
  default     = "32m"
}

variable "thanos_ruler_request_memory" {
  type        = string
  description = "Memory resource request for Thanos Ruler"
  default     = "64Mi"
}

variable "thanos_ruler_limit_cpu" {
  type        = string
  description = "CPU resource limit for Thanos Ruler"
  default     = "128m"
}

variable "thanos_ruler_limit_memory" {
  type        = string
  description = "Memory resource limit for Thanos Ruler"
  default     = "256Mi"
}

// =========================
// Prometheus Basic Auth variables
// =========================
// Controls basic authentication for Prometheus ingress.
variable "prometheus_htpasswd" {
  type        = string
  description = "HTPASSWD for Prometheus basic authentication"
  sensitive   = true
}

variable "prometheus_alertmanager_htpasswd" {
  type        = string
  description = "HTPASSWD for Prometheus Alertmanager basic authentication"
  sensitive   = true
}