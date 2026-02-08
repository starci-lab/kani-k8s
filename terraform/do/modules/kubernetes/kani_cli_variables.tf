// =========================
// Kani CLI application configuration
// =========================
// Controls basic application settings like replica count and port.

// Number of pod replicas for Kani CLI
variable "kani_cli_replica_count" {
  type        = number
  description = "Number of pod replicas for Kani CLI"
  default     = 1
}

// Port number for Kani CLI application
variable "kani_cli_port" {
  type        = number
  description = "Port number for Kani CLI application"
  default     = 3000
}

// =========================
// Kani CLI resource variables
// =========================
// Controls resource allocation for Kani CLI pods.

// CPU resource request for Kani CLI
variable "kani_cli_request_cpu" {
  type        = string
  description = "CPU resource request for Kani CLI"
  nullable    = true
  default     = null
}

// Memory resource request for Kani CLI
variable "kani_cli_request_memory" {
  type        = string
  description = "Memory resource request for Kani CLI"
  nullable    = true
  default     = null
}

// CPU resource limit for Kani CLI
variable "kani_cli_limit_cpu" {
  type        = string
  description = "CPU resource limit for Kani CLI"
  nullable    = true
  default     = null
}

// Memory resource limit for Kani CLI
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

// Image for the Kani CLI
variable "kani_cli_image_repository" {
  type        = string
  description = "Image for the Kani CLI"
  default     = "kanibot/kani-cli"
}

// Tag for the Kani CLI
variable "kani_cli_image_tag" {
  type        = string
  description = "Tag for the Kani CLI"
  default     = "latest"
}
