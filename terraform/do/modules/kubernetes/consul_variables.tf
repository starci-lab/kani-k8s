// =========================
// Consul replica count
// =========================

variable "consul_replica_count" {
  type        = number
  description = "Number of HashiCorp Consul server replicas"
  default     = 3
}

// =========================
// Consul persistence
// =========================

variable "consul_persistence_size" {
  type        = string
  description = "Persistent volume size for Consul data"
  default     = "8Gi"
}

// =========================
// Consul gossip key (optional)
// =========================
// Base64-encoded gossip key for cluster encryption; leave empty to disable.

variable "consul_gossip_key" {
  type        = string
  description = "Base64-encoded gossip key for Consul cluster encryption (optional)"
  default     = ""
  sensitive   = true
}

// =========================
// Consul container resources
// =========================

variable "consul_request_cpu" {
  type        = string
  description = "CPU resource request for Consul server"
  nullable    = true
  default     = null
}

variable "consul_request_memory" {
  type        = string
  description = "Memory resource request for Consul server"
  nullable    = true
  default     = null
}

variable "consul_limit_cpu" {
  type        = string
  description = "CPU resource limit for Consul server"
  nullable    = true
  default     = null
}

variable "consul_limit_memory" {
  type        = string
  description = "Memory resource limit for Consul server"
  nullable    = true
  default     = null
}

// =========================
// Volume permissions init container
// =========================

variable "consul_volume_permissions_request_cpu" {
  type        = string
  description = "CPU resource request for Consul volume permissions init container"
  nullable    = true
  default     = null
}

variable "consul_volume_permissions_request_memory" {
  type        = string
  description = "Memory resource request for Consul volume permissions init container"
  nullable    = true
  default     = null
}

variable "consul_volume_permissions_limit_cpu" {
  type        = string
  description = "CPU resource limit for Consul volume permissions init container"
  nullable    = true
  default     = null
}

variable "consul_volume_permissions_limit_memory" {
  type        = string
  description = "Memory resource limit for Consul volume permissions init container"
  nullable    = true
  default     = null
}

// =========================
// Consul resource presets and computed locals
// =========================

locals {
  consul_presets = {
    consul             = "64"
    volume_permissions = "16"
  }
}

locals {
  consul = {
    consul = {
      request_cpu    = coalesce(var.consul_request_cpu, try(var.resources_config[local.consul_presets.consul].requests.cpu, "100m"))
      request_memory = coalesce(var.consul_request_memory, try(var.resources_config[local.consul_presets.consul].requests.memory, "128Mi"))
      limit_cpu      = coalesce(var.consul_limit_cpu, try(var.resources_config[local.consul_presets.consul].limits.cpu, "256m"))
      limit_memory   = coalesce(var.consul_limit_memory, try(var.resources_config[local.consul_presets.consul].limits.memory, "256Mi"))
    }
    volume_permissions = {
      request_cpu    = coalesce(var.consul_volume_permissions_request_cpu, try(var.resources_config[local.consul_presets.volume_permissions].requests.cpu, "32m"))
      request_memory = coalesce(var.consul_volume_permissions_request_memory, try(var.resources_config[local.consul_presets.volume_permissions].requests.memory, "64Mi"))
      limit_cpu      = coalesce(var.consul_volume_permissions_limit_cpu, try(var.resources_config[local.consul_presets.volume_permissions].limits.cpu, "128m"))
      limit_memory   = coalesce(var.consul_volume_permissions_limit_memory, try(var.resources_config[local.consul_presets.volume_permissions].limits.memory, "128Mi"))
    }
  }
}
