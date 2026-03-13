// =========================
// NATS variables
// =========================

variable "nats_replica_count" {
  type        = number
  description = "Number of NATS server replicas"
  default     = 1
}

variable "nats_request_cpu" {
  type        = string
  description = "NATS container CPU request"
  default     = null
}

variable "nats_request_memory" {
  type        = string
  description = "NATS container memory request"
  default     = null
}

variable "nats_limit_cpu" {
  type        = string
  description = "NATS container CPU limit"
  default     = null
}

variable "nats_limit_memory" {
  type        = string
  description = "NATS container memory limit"
  default     = null
}

variable "nats_auth_enabled" {
  type        = bool
  description = "Enable NATS client authentication"
  default     = false
}

variable "nats_auth_token" {
  type        = string
  description = "NATS auth token (when auth enabled)"
  sensitive   = true
}
