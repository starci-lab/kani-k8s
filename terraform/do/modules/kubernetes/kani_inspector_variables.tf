// =========================
// Kani Inspector application configuration
// =========================
// Controls basic application settings like replica count and port.

variable "kani_inspector_replica_count" {
  type        = number
  description = "Number of pod replicas for Kani Inspector"
  default     = 1
}

variable "kani_inspector_port" {
  type        = number
  description = "Port number for Kani Inspector application"
  default     = 3000
}

// =========================
// Kani Inspector resource variables
// =========================
// Controls resource allocation for Kani Inspector pods.

variable "kani_inspector_request_cpu" {
  type        = string
  description = "CPU resource request for Kani Inspector"
  nullable    = true
  default     = null
}

variable "kani_inspector_request_memory" {
  type        = string
  description = "Memory resource request for Kani Inspector"
  nullable    = true
  default     = null
}

variable "kani_inspector_limit_cpu" {
  type        = string
  description = "CPU resource limit for Kani Inspector"
  nullable    = true
  default     = null
}

variable "kani_inspector_limit_memory" {
  type        = string
  description = "Memory resource limit for Kani Inspector"
  nullable    = true
  default     = null
}

// =========================
// Kani Inspector image
// =========================
// Configures the image for the Kani Inspector.

variable "kani_inspector_image_repository" {
  type        = string
  description = "Image for the Kani Inspector"
  default     = "kanibot/kani-inspector"
}

variable "kani_inspector_image_tag" {
  type        = string
  description = "Tag for the Kani Inspector"
  default     = "latest"
}

// =========================
// Kani Inspector Ingress
// =========================
// Host for the Inspector API Ingress (e.g. inspector-api.kanibot.xyz).

variable "kani_inspector_ingress_host" {
  type        = string
  description = "Hostname for Kani Inspector Ingress"
  default     = ""
}
