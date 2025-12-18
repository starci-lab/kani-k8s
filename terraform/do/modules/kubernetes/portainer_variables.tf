// =========================
// Portainer resource variables
// =========================
// Controls resource allocation for Portainer server.

variable "portainer_request_cpu" {
  type        = string
  description = "CPU resource request for Portainer server"
  nullable    = true
  default     = null
}

variable "portainer_request_memory" {
  type        = string
  description = "Memory resource request for Portainer server"
  nullable    = true
  default     = null
}

variable "portainer_limit_cpu" {
  type        = string
  description = "CPU resource limit for Portainer server"
  nullable    = true
  default     = null
}

variable "portainer_limit_memory" {
  type        = string
  description = "Memory resource limit for Portainer server"
  nullable    = true
  default     = null
}

variable "portainer_persistence_size" {
  type        = string
  description = "Persistent volume size for Portainer data"
  default     = "2Gi"
}

locals {
  portainer_presets = {
    portainer = "16"
  }
}

locals {
  portainer = {
    portainer = {
      request_cpu = coalesce(
        var.portainer_request_cpu,
        try(var.resources_config[local.portainer_presets.portainer].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.portainer_request_memory,
        try(var.resources_config[local.portainer_presets.portainer].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.portainer_limit_cpu,
        try(var.resources_config[local.portainer_presets.portainer].limits.cpu, "64m")
      )
      limit_memory = coalesce(
        var.portainer_limit_memory,
        try(var.resources_config[local.portainer_presets.portainer].limits.memory, "128Mi")
      )
    }
  }
}