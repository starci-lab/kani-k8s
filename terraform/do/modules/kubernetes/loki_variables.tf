// =========================
// Loki replica counts
// =========================
// Controls replica counts for all Loki components.

// Number of replicas for Loki gateway
variable "loki_gateway_replica_count" {
  type        = number
  description = "Number of Loki gateway replicas"
  default     = 1
}

// Number of replicas for Loki compactor
variable "loki_compactor_replica_count" {
  type        = number
  description = "Number of Loki compactor replicas"
  default     = 1
}

// Number of replicas for Loki distributor
variable "loki_distributor_replica_count" {
  type        = number
  description = "Number of Loki distributor replicas"
  default     = 1
}

// Number of replicas for Loki ingester
variable "loki_ingester_replica_count" {
  type        = number
  description = "Number of Loki ingester replicas"
  default     = 1
}

// Number of replicas for Loki querier
variable "loki_querier_replica_count" {
  type        = number
  description = "Number of Loki querier replicas"
  default     = 1
}

// Number of replicas for Loki query frontend
variable "loki_query_frontend_replica_count" {
  type        = number
  description = "Number of Loki query frontend replicas"
  default     = 1
}

// =========================
// Loki persistence
// =========================
// Controls persistent volume sizes for Loki components.

// Persistent volume size for Loki compactor
variable "loki_compactor_persistence_size" {
  type        = string
  description = "Persistent volume size for Loki compactor"
  default     = "8Gi"
}

// Persistent volume size for Loki ingester
variable "loki_ingester_persistence_size" {
  type        = string
  description = "Persistent volume size for Loki ingester"
  default     = "8Gi"
}

// Persistent volume size for Loki querier
variable "loki_querier_persistence_size" {
  type        = string
  description = "Persistent volume size for Loki querier"
  default     = "8Gi"
}

// =========================
// Loki gateway resource variables
// =========================
// Controls resource allocation for Loki gateway.

// CPU resource request for Loki gateway
variable "loki_gateway_request_cpu" {
  type        = string
  description = "CPU resource request for Loki gateway"
  nullable    = true
  default     = null
}

// Memory resource request for Loki gateway
variable "loki_gateway_request_memory" {
  type        = string
  description = "Memory resource request for Loki gateway"
  nullable    = true
  default     = null
}

// CPU resource limit for Loki gateway
variable "loki_gateway_limit_cpu" {
  type        = string
  description = "CPU resource limit for Loki gateway"
  nullable    = true
  default     = null
}

// Memory resource limit for Loki gateway
variable "loki_gateway_limit_memory" {
  type        = string
  description = "Memory resource limit for Loki gateway"
  nullable    = true
  default     = null
}

// =========================
// Loki compactor resource variables
// =========================
// Controls resource allocation for Loki compactor.

// CPU resource request for Loki compactor
variable "loki_compactor_request_cpu" {
  type        = string
  description = "CPU resource request for Loki compactor"
  nullable    = true
  default     = null
}

// Memory resource request for Loki compactor
variable "loki_compactor_request_memory" {
  type        = string
  description = "Memory resource request for Loki compactor"
  nullable    = true
  default     = null
}

// CPU resource limit for Loki compactor
variable "loki_compactor_limit_cpu" {
  type        = string
  description = "CPU resource limit for Loki compactor"
  nullable    = true
  default     = null
}

// Memory resource limit for Loki compactor
variable "loki_compactor_limit_memory" {
  type        = string
  description = "Memory resource limit for Loki compactor"
  nullable    = true
  default     = null
}
