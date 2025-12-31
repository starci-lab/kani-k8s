// =========================
// Kani CLI application configuration
// =========================
// Controls basic application settings like replica count and port.

variable "kani_cli_replica_count" {
  type        = number
  description = "Number of pod replicas for Kani CLI"
  default     = 1
}

variable "kani_cli_port" {
  type        = number
  description = "Port number for Kani CLI application"
  default     = 3000
}


// =========================
// Kani CLI resource variables
// =========================
// Controls resource allocation for Kani CLI pods.

variable "kani_cli_request_cpu" {
  type        = string
  description = "CPU resource request for Kani CLI"
  nullable    = true
  default     = null
}

variable "kani_cli_request_memory" {
  type        = string
  description = "Memory resource request for Kani CLI"
  nullable    = true
  default     = null
}

variable "kani_cli_limit_cpu" {
  type        = string
  description = "CPU resource limit for Kani CLI"
  nullable    = true
  default     = null
}

variable "kani_cli_limit_memory" {
  type        = string
  description = "Memory resource limit for Kani CLI"
  nullable    = true
  default     = null
}

// =========================
// Kani CLI image
// =========================
// Configures the image for the Kani CLI.

variable "kani_cli_image_repository" {
  type        = string
  description = "Image for the Kani CLI"
  default     = "kanibot/kani-cli"
}

variable "kani_cli_image_tag" {
  type        = string
  description = "Tag for the Kani CLI"
  default     = "latest"
}

// =========================
// Kani CLI resource presets
// =========================
// Defines preset resource configurations that can be referenced
// via the resources_config variable.

locals {
  kani_cli_presets = {
    kani_cli = "64"
  }
}

// =========================
// Kani CLI resource configuration
// =========================
// Resolves resource requests and limits using either explicit
// variables or fallback to preset configurations from resources_config.

locals {
  kani_cli = {
    kani_cli = {
      request_cpu = coalesce(
        var.kani_cli_request_cpu,
        try(var.resources_config[local.kani_cli_presets.kani_cli].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.kani_cli_request_memory,
        try(var.resources_config[local.kani_cli_presets.kani_cli].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.kani_cli_limit_cpu,
        try(var.resources_config[local.kani_cli_presets.kani_cli].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.kani_cli_limit_memory,
        try(var.resources_config[local.kani_cli_presets.kani_cli].limits.memory, "256Mi")
      )
    }
  }
}

