// =========================
// Loki Monolithic configuration
// =========================
// Variables for Grafana Loki Helm chart in SingleBinary (monolithic) mode.
// Used by loki-monilithic.yaml template.

// Replication factor for Loki single-binary (1 = single pod, 3 = HA)
variable "loki_monolithic_replication_factor" {
  type        = number
  description = "Replication factor for Loki monolithic deployment"
  default     = 1
}

// =========================
// Loki Monolithic resources
// =========================

// CPU resource request for Loki monolithic single-binary
variable "loki_monolithic_request_cpu" {
  type        = string
  description = "CPU resource request for Loki monolithic"
  default     = null
  nullable    = true
}

// Memory resource request for Loki monolithic single-binary
variable "loki_monolithic_request_memory" {
  type        = string
  description = "Memory resource request for Loki monolithic"
  default     = null
  nullable    = true
}

// CPU resource limit for Loki monolithic single-binary
variable "loki_monolithic_limit_cpu" {
  type        = string
  description = "CPU resource limit for Loki monolithic"
  default     = null
  nullable    = true
}

// Memory resource limit for Loki monolithic single-binary
variable "loki_monolithic_limit_memory" {
  type        = string
  description = "Memory resource limit for Loki monolithic"
  default     = null
  nullable    = true
}

// =========================
// Loki Monolithic persistence
// =========================

// Persistent volume size for Loki monolithic single-binary
variable "loki_monolithic_persistence_size" {
  type        = string
  description = "Persistent volume size for Loki monolithic data"
  default     = "10Gi"
}

// =========================
// Loki Monolithic canary resources
// =========================

// CPU resource request for Loki monolithic canary
variable "loki_monolithic_canary_request_cpu" {
  type        = string
  description = "CPU resource request for Loki monolithic canary"
  default     = null
  nullable    = true
}

// Memory resource request for Loki monolithic canary
variable "loki_monolithic_canary_request_memory" {
  type        = string
  description = "Memory resource request for Loki monolithic canary"
  default     = null
  nullable    = true
}

// CPU resource limit for Loki monolithic canary
variable "loki_monolithic_canary_limit_cpu" {
  type        = string
  description = "CPU resource limit for Loki monolithic canary"
  default     = null
  nullable    = true
}

// Memory resource limit for Loki monolithic canary
variable "loki_monolithic_canary_limit_memory" {
  type        = string
  description = "Memory resource limit for Loki monolithic canary"
  default     = null
  nullable    = true
}

// Number of replicas for Loki monolithic canary
variable "loki_monolithic_canary_replicas" {
  type        = number
  description = "Number of replicas for Loki monolithic canary"
  default     = 1
}

// =========================
// Loki Monolithic Gateway
// =========================
// Gateway (NGINX) in front of Loki monolithic; preset usage = 32.

// Number of replicas for Loki monolithic gateway
variable "loki_monolithic_gateway_replicas" {
  type        = number
  description = "Number of replicas for Loki monolithic gateway"
  default     = 1
}

// CPU resource request for Loki monolithic gateway
variable "loki_monolithic_gateway_request_cpu" {
  type        = string
  description = "CPU resource request for Loki monolithic gateway"
  default     = null
  nullable    = true
}

// Memory resource request for Loki monolithic gateway
variable "loki_monolithic_gateway_request_memory" {
  type        = string
  description = "Memory resource request for Loki monolithic gateway"
  default     = null
  nullable    = true
}

// CPU resource limit for Loki monolithic gateway
variable "loki_monolithic_gateway_limit_cpu" {
  type        = string
  description = "CPU resource limit for Loki monolithic gateway"
  default     = null
  nullable    = true
}

// Memory resource limit for Loki monolithic gateway
variable "loki_monolithic_gateway_limit_memory" {
  type        = string
  description = "Memory resource limit for Loki monolithic gateway"
  default     = null
  nullable    = true
}