// =========================
// Loki replica counts
// =========================

variable "loki_gateway_replica_count" {
  type        = number
  description = "Number of Loki gateway replicas"
  default     = 1
}

variable "loki_compactor_replica_count" {
  type        = number
  description = "Number of Loki compactor replicas"
  default     = 1
}

variable "loki_distributor_replica_count" {
  type        = number
  description = "Number of Loki distributor replicas"
  default     = 1
}

variable "loki_ingester_replica_count" {
  type        = number
  description = "Number of Loki ingester replicas"
  default     = 1
}

variable "loki_querier_replica_count" {
  type        = number
  description = "Number of Loki querier replicas"
  default     = 1
}

variable "loki_query_frontend_replica_count" {
  type        = number
  description = "Number of Loki query frontend replicas"
  default     = 1
}

// =========================
// Loki persistence
// =========================

variable "loki_compactor_persistence_size" {
  type        = string
  description = "Persistent volume size for Loki compactor"
  default     = "8Gi"
}

variable "loki_ingester_persistence_size" {
  type        = string
  description = "Persistent volume size for Loki ingester"
  default     = "8Gi"
}

variable "loki_querier_persistence_size" {
  type        = string
  description = "Persistent volume size for Loki querier"
  default     = "8Gi"
}

// =========================
// Loki gateway resources
// =========================

variable "loki_gateway_request_cpu" {
  type        = string
  description = "CPU resource request for Loki gateway"
  nullable    = true
  default     = null
}

variable "loki_gateway_request_memory" {
  type        = string
  description = "Memory resource request for Loki gateway"
  nullable    = true
  default     = null
}

variable "loki_gateway_limit_cpu" {
  type        = string
  description = "CPU resource limit for Loki gateway"
  nullable    = true
  default     = null
}

variable "loki_gateway_limit_memory" {
  type        = string
  description = "Memory resource limit for Loki gateway"
  nullable    = true
  default     = null
}

// =========================
// Loki compactor resources
// =========================

variable "loki_compactor_request_cpu" {
  type        = string
  description = "CPU resource request for Loki compactor"
  nullable    = true
  default     = null
}

variable "loki_compactor_request_memory" {
  type        = string
  description = "Memory resource request for Loki compactor"
  nullable    = true
  default     = null
}

variable "loki_compactor_limit_cpu" {
  type        = string
  description = "CPU resource limit for Loki compactor"
  nullable    = true
  default     = null
}

variable "loki_compactor_limit_memory" {
  type        = string
  description = "Memory resource limit for Loki compactor"
  nullable    = true
  default     = null
}

// =========================
// Loki resource presets and computed locals
// =========================

locals {
  loki_presets = {
    gateway   = "16"
    compactor = "16"
  }
}

locals {
  loki = {
    gateway = {
      request_cpu    = coalesce(var.loki_gateway_request_cpu, try(var.resources_config[local.loki_presets.gateway].requests.cpu, "50m"))
      request_memory = coalesce(var.loki_gateway_request_memory, try(var.resources_config[local.loki_presets.gateway].requests.memory, "64Mi"))
      limit_cpu      = coalesce(var.loki_gateway_limit_cpu, try(var.resources_config[local.loki_presets.gateway].limits.cpu, "200m"))
      limit_memory   = coalesce(var.loki_gateway_limit_memory, try(var.resources_config[local.loki_presets.gateway].limits.memory, "128Mi"))
    }
    compactor = {
      request_cpu    = coalesce(var.loki_compactor_request_cpu, try(var.resources_config[local.loki_presets.compactor].requests.cpu, "50m"))
      request_memory = coalesce(var.loki_compactor_request_memory, try(var.resources_config[local.loki_presets.compactor].requests.memory, "64Mi"))
      limit_cpu      = coalesce(var.loki_compactor_limit_cpu, try(var.resources_config[local.loki_presets.compactor].limits.cpu, "200m"))
      limit_memory   = coalesce(var.loki_compactor_limit_memory, try(var.resources_config[local.loki_presets.compactor].limits.memory, "128Mi"))
    }
  }
}
