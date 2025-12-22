// =========================
// Kani Coordinator application configuration
// =========================
// Controls basic application settings like replica count and port.

variable "kani_coordinator_replica_count" {
  type        = number
  description = "Number of pod replicas for Kani Coordinator"
  default     = 1
}

variable "kani_coordinator_port" {
  type        = number
  description = "Port number for Kani Coordinator application"
  default     = 3000
}


// =========================
// Kani Coordinator resource variables
// =========================
// Controls resource allocation for Kani Coordinator pods.

variable "kani_coordinator_request_cpu" {
  type        = string
  description = "CPU resource request for Kani Coordinator"
  nullable    = true
  default     = null
}

variable "kani_coordinator_request_memory" {
  type        = string
  description = "Memory resource request for Kani Coordinator"
  nullable    = true
  default     = null
}

variable "kani_coordinator_limit_cpu" {
  type        = string
  description = "CPU resource limit for Kani Coordinator"
  nullable    = true
  default     = null
}

variable "kani_coordinator_limit_memory" {
  type        = string
  description = "Memory resource limit for Kani Coordinator"
  nullable    = true
  default     = null
}

// =========================
// Kani Executor image
// =========================
// Configures the image for the Kani Executor.

variable "kani_executor_image" {
  type        = string
  description = "Image for the Kani Executor"
  default     = "kanibot/kani-executor:latest"
}

// =========================
// Kani Coordinator resource presets
// =========================
// Defines preset resource configurations that can be referenced
// via the resources_config variable.

locals {
  kani_coordinator_presets = {
    kani_coordinator = "64"
  }
}

// =========================
// Kani Coordinator resource configuration
// =========================
// Resolves resource requests and limits using either explicit
// variables or fallback to preset configurations from resources_config.

locals {
  kani_coordinator = {
    kani_coordinator = {
      request_cpu = coalesce(
        var.kani_coordinator_request_cpu,
        try(var.resources_config[local.kani_coordinator_presets.kani_coordinator].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.kani_coordinator_request_memory,
        try(var.resources_config[local.kani_coordinator_presets.kani_coordinator].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.kani_coordinator_limit_cpu,
        try(var.resources_config[local.kani_coordinator_presets.kani_coordinator].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.kani_coordinator_limit_memory,
        try(var.resources_config[local.kani_coordinator_presets.kani_coordinator].limits.memory, "256Mi")
      )
    }
  }
}

