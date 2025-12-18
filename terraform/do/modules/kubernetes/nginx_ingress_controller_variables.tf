// =========================
// NGINX Ingress Controller variables
// =========================
// Controls resource allocation for the NGINX Ingress Controller,
// which handles external HTTP/HTTPS traffic entering the cluster.

variable "nginx_ingress_controller_replica_count" {
  type        = number
  description = "Number of replicas for the NGINX Ingress Controller"
  default     = 1
}

variable "nginx_ingress_controller_request_cpu" {
  type        = string
  description = "CPU resource request for the NGINX Ingress Controller"
  nullable    = true
  default     = null
}

variable "nginx_ingress_controller_request_memory" {
  type        = string
  description = "Memory resource request for the NGINX Ingress Controller"
  nullable    = true
  default     = null
}

variable "nginx_ingress_controller_limit_cpu" {
  type        = string
  description = "CPU resource limit for the NGINX Ingress Controller (4x request)"
  nullable    = true
  default     = null
}

variable "nginx_ingress_controller_limit_memory" {
  type        = string
  description = "Memory resource limit for the NGINX Ingress Controller (4x request)"
  nullable    = true
  default     = null
}

// =========================
// NGINX Ingress default backend variables
// =========================
// Controls resource allocation for the default backend,
// which serves fallback responses (e.g. 404) when no ingress rule matches.

variable "nginx_ingress_controller_default_backend_request_cpu" {
  type        = string
  description = "CPU resource request for the NGINX Ingress default backend"
  nullable    = true
  default     = null
}

variable "nginx_ingress_controller_default_backend_request_memory" {
  type        = string
  description = "Memory resource request for the NGINX Ingress default backend"
  nullable    = true
  default     = null
}

variable "nginx_ingress_controller_default_backend_limit_cpu" {
  type        = string
  description = "CPU resource limit for the NGINX Ingress default backend (4x request)"
  nullable    = true
  default     = null
}

variable "nginx_ingress_controller_default_backend_limit_memory" {
  type        = string
  description = "Memory resource limit for the NGINX Ingress default backend (4x request)"
  nullable    = true
  default     = null
}

locals {
  nginx_ingress_controller_presets = {
    controller     = "32"
    default_backend = "16"
  }
}

locals {
  nginx_ingress_controller = {
    controller = {
      request_cpu = coalesce(
        var.nginx_ingress_controller_request_cpu,
        try(var.resources_config[local.nginx_ingress_controller_presets.controller].requests.cpu, "64m")
      )
      request_memory = coalesce(
        var.nginx_ingress_controller_request_memory,
        try(var.resources_config[local.nginx_ingress_controller_presets.controller].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.nginx_ingress_controller_limit_cpu,
        try(var.resources_config[local.nginx_ingress_controller_presets.controller].limits.cpu, "256m")
      )
      limit_memory = coalesce(
        var.nginx_ingress_controller_limit_memory,
        try(var.resources_config[local.nginx_ingress_controller_presets.controller].limits.memory, "512Mi")
      )
    }

    default_backend = {
      request_cpu = coalesce(
        var.nginx_ingress_controller_default_backend_request_cpu,
        try(var.resources_config[local.nginx_ingress_controller_presets.default_backend].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.nginx_ingress_controller_default_backend_request_memory,
        try(var.resources_config[local.nginx_ingress_controller_presets.default_backend].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.nginx_ingress_controller_default_backend_limit_cpu,
        try(var.resources_config[local.nginx_ingress_controller_presets.default_backend].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.nginx_ingress_controller_default_backend_limit_memory,
        try(var.resources_config[local.nginx_ingress_controller_presets.default_backend].limits.memory, "256Mi")
      )
    }
  }
}