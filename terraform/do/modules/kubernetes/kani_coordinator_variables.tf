// =========================
// Kani Coordinator application configuration
// =========================
// Controls basic application settings like replica count and port.

// Number of pod replicas for Kani Coordinator
variable "kani_coordinator_replica_count" {
  type        = number
  description = "Number of pod replicas for Kani Coordinator"
  default     = 1
}

// Port number for Kani Coordinator application
variable "kani_coordinator_port" {
  type        = number
  description = "Port number for Kani Coordinator application"
  default     = 3000
}

// =========================
// Kani Coordinator resource variables
// =========================
// Controls resource allocation for Kani Coordinator pods.

// CPU resource request for Kani Coordinator
variable "kani_coordinator_request_cpu" {
  type        = string
  description = "CPU resource request for Kani Coordinator"
  nullable    = true
  default     = null
}

// Memory resource request for Kani Coordinator
variable "kani_coordinator_request_memory" {
  type        = string
  description = "Memory resource request for Kani Coordinator"
  nullable    = true
  default     = null
}

// CPU resource limit for Kani Coordinator
variable "kani_coordinator_limit_cpu" {
  type        = string
  description = "CPU resource limit for Kani Coordinator"
  nullable    = true
  default     = null
}

// Memory resource limit for Kani Coordinator
variable "kani_coordinator_limit_memory" {
  type        = string
  description = "Memory resource limit for Kani Coordinator"
  nullable    = true
  default     = null
}

// =========================
// Kani Coordinator image
// =========================
// Configures the image for the Kani Coordinator.

// Image for the Kani Coordinator
variable "kani_coordinator_image_repository" {
  type        = string
  description = "Image for the Kani Coordinator"
  default     = "kanibot/kani-coordinator"
}

// Tag for the Kani Coordinator
variable "kani_coordinator_image_tag" {
  type        = string
  description = "Tag for the Kani Coordinator"
  default     = "latest"
}