// =========================
// Kani Interface application configuration
// =========================
// Controls basic application settings like replica count and port.

variable "kani_interface_replica_count" {
  type        = number
  description = "Number of pod replicas for Kani Interface"
  default     = 1
}

variable "kani_interface_port" {
  type        = number
  description = "Port number for Kani Interface application"
  default     = 3000
}

// =========================
// Kani Interface resource variables
// =========================
// Controls resource allocation for Kani Interface pods.

variable "kani_interface_request_cpu" {
  type        = string
  description = "CPU resource request for Kani Interface"
  nullable    = true
  default     = null
}

variable "kani_interface_request_memory" {
  type        = string
  description = "Memory resource request for Kani Interface"
  nullable    = true
  default     = null
}

variable "kani_interface_limit_cpu" {
  type        = string
  description = "CPU resource limit for Kani Interface"
  nullable    = true
  default     = null
}

variable "kani_interface_limit_memory" {
  type        = string
  description = "Memory resource limit for Kani Interface"
  nullable    = true
  default     = null
}

// =========================
// Kani Interface image
// =========================
// Configures the image for the Kani Interface.

variable "kani_interface_image_repository" {
  type        = string
  description = "Image for the Kani Interface"
  default     = "kanibot/kani-interface"
}

variable "kani_interface_image_tag" {
  type        = string
  description = "Tag for the Kani Interface"
  default     = "latest"
}

