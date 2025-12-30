// =========================
// Kani Observer application configuration
// =========================
// Controls basic application settings like replica count and port.

variable "kani_observer_replica_count" {
  type        = number
  description = "Number of pod replicas for Kani Observer"
  default     = 1
}

variable "kani_observer_port" {
  type        = number
  description = "Port number for Kani Observer application"
  default     = 3000
}


// =========================
// Kani Observer resource variables
// =========================
// Controls resource allocation for Kani Observer pods.

variable "kani_observer_request_cpu" {
  type        = string
  description = "CPU resource request for Kani Observer"
  nullable    = true
  default     = null
}

variable "kani_observer_request_memory" {
  type        = string
  description = "Memory resource request for Kani Observer"
  nullable    = true
  default     = null
}

variable "kani_observer_limit_cpu" {
  type        = string
  description = "CPU resource limit for Kani Observer"
  nullable    = true
  default     = null
}

variable "kani_observer_limit_memory" {
  type        = string
  description = "Memory resource limit for Kani Observer"
  nullable    = true
  default     = null
}

// =========================
// Kani Observer image
// =========================
// Configures the image for the Kani Observer.

variable "kani_observer_image" {
  type        = string
  description = "Image for the Kani Observer"
  default     = "kanibot/kani-observer:latest"
}

// =========================
// Kani Observer resource presets
// =========================
// Defines preset resource configurations that can be referenced
// via the resources_config variable.

locals {
  kani_observer_presets = {
    kani_observer = "64"
  }
}

// =========================
// Kani Observer resource configuration
// =========================
// Resolves resource requests and limits using either explicit
// variables or fallback to preset configurations from resources_config.

locals {
  kani_observer = {
    kani_observer = {
      request_cpu = coalesce(
        var.kani_observer_request_cpu,
        try(var.resources_config[local.kani_observer_presets.kani_observer].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.kani_observer_request_memory,
        try(var.resources_config[local.kani_observer_presets.kani_observer].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.kani_observer_limit_cpu,
        try(var.resources_config[local.kani_observer_presets.kani_observer].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.kani_observer_limit_memory,
        try(var.resources_config[local.kani_observer_presets.kani_observer].limits.memory, "256Mi")
      )
    }
  }
}

