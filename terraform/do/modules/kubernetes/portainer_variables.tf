// =========================
// Portainer resource variables
// =========================
// Controls resource allocation for Portainer server.

variable "portainer_request_cpu" {
  type        = string
  description = "CPU resource request for Portainer server"
  default     = "32m"
}

variable "portainer_request_memory" {
  type        = string
  description = "Memory resource request for Portainer server"
  default     = "64Mi"
}

variable "portainer_limit_cpu" {
  type        = string
  description = "CPU resource limit for Portainer server"
  default     = "64m"
}

variable "portainer_limit_memory" {
  type        = string
  description = "Memory resource limit for Portainer server"
  default     = "128Mi"
}

variable "portainer_persistence_size" {
  type        = string
  description = "Persistent volume size for Portainer data"
  default     = "2Gi"
}