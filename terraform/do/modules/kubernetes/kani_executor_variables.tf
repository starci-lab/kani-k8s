// =========================
// Kani Coordinator application configuration
// =========================
// Controls basic application settings like replica count and port.

variable "kani_executor_replica_count" {
  type        = number
  description = "Number of pod replicas for Kani Executor"
  default     = 1
}

variable "kani_executor_port" {
  type        = number
  description = "Port number for Kani Executor application"
  default     = 3000
}


// =========================
// Kani Coordinator resource variables
// =========================
// Controls resource allocation for Kani Coordinator pods.

variable "kani_executor_request_cpu" {
  type        = string
  description = "CPU resource request for Kani Executor"
  nullable    = true
  default     = null
}

variable "kani_executor_request_memory" {
  type        = string
  description = "Memory resource request for Kani Executor"
  nullable    = true
  default     = null
}

variable "kani_executor_limit_cpu" {
  type        = string
  description = "CPU resource limit for Kani Executor"
  nullable    = true
  default     = null
}

variable "kani_executor_limit_memory" {
  type        = string
  description = "Memory resource limit for Kani Executor"
  nullable    = true
  default     = null
}

// =========================
// Kani Coordinator resource presets
// =========================
// Defines preset resource configurations that can be referenced
// via the resources_config variable.

locals {
  kani_executor_presets = {
    kani_executor = "64"
  }
}

// =========================
// Kani Executor resource configuration
// =========================
// Resolves resource requests and limits using either explicit
// variables or fallback to preset configurations from resources_config.

locals {
  kani_executor = {
    kani_executor = {
      request_cpu = coalesce(
        var.kani_executor_request_cpu,
        try(var.resources_config[local.kani_executor_presets.kani_executor].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.kani_executor_request_memory,
        try(var.resources_config[local.kani_executor_presets.kani_executor].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.kani_executor_limit_cpu,
        try(var.resources_config[local.kani_executor_presets.kani_executor].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.kani_executor_limit_memory,
        try(var.resources_config[local.kani_executor_presets.kani_executor].limits.memory, "256Mi")
      )
    }
  }
}

