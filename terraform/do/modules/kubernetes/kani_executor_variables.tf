// =========================
// Kani Executor application configuration
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
// Kani Executor resource variables
// =========================
// Controls resource allocation for Kani Executor pods.

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
// Kani Executor image
// =========================
// Configures the image for the Kani Executor.
variable "kani_executor_image_repository" {
  type        = string
  description = "Image for the Kani Executor"
  default     = "kanibot/kani-executor"
}

variable "kani_executor_image_tag" {
  type        = string
  description = "Tag for the Kani Executor"
  default     = "latest"
}

