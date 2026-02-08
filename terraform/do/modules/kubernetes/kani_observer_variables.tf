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

variable "kani_observer_image_repository" {
  type        = string
  description = "Image for the Kani Observer"
  default     = "kanibot/kani-observer"
}

variable "kani_observer_image_tag" {
  type        = string
  description = "Tag for the Kani Observer"
  default     = "latest"
}

