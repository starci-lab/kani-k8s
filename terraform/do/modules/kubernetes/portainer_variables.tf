// =========================
// Portainer replica count
// =========================
// Controls replica count for Portainer server.

// Number of replicas for Portainer server
variable "portainer_replica_count" {
  type        = number
  description = "Number of Portainer replicas"
  default     = 1
}

// =========================
// Portainer resource variables
// =========================
// Controls resource allocation for Portainer server.

// CPU resource request for Portainer server
variable "portainer_request_cpu" {
  type        = string
  description = "CPU resource request for Portainer server"
  nullable    = true
  default     = null
}

// Memory resource request for Portainer server
variable "portainer_request_memory" {
  type        = string
  description = "Memory resource request for Portainer server"
  nullable    = true
  default     = null
}

// CPU resource limit for Portainer server
variable "portainer_limit_cpu" {
  type        = string
  description = "CPU resource limit for Portainer server"
  nullable    = true
  default     = null
}

// Memory resource limit for Portainer server
variable "portainer_limit_memory" {
  type        = string
  description = "Memory resource limit for Portainer server"
  nullable    = true
  default     = null
}

// =========================
// Portainer persistence variables
// =========================
// Controls persistent volume size for Portainer data.

// Persistent volume size for Portainer data
variable "portainer_persistence_size" {
  type        = string
  description = "Persistent volume size for Portainer data"
  default     = "2Gi"
}
