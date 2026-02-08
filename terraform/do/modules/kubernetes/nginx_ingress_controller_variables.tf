// =========================
// NGINX Ingress Controller variables
// =========================
// Controls resource allocation for the NGINX Ingress Controller,
// which handles external HTTP/HTTPS traffic entering the cluster.

// Number of replicas for the NGINX Ingress Controller
variable "nginx_ingress_controller_replica_count" {
  type        = number
  description = "Number of replicas for the NGINX Ingress Controller"
  default     = 1
}

// Number of replicas for the NGINX Ingress default backend
variable "nginx_ingress_controller_default_backend_replica_count" {
  type        = number
  description = "Number of replicas for the NGINX Ingress default backend"
  default     = 1
}

// CPU resource request for the NGINX Ingress Controller
variable "nginx_ingress_controller_request_cpu" {
  type        = string
  description = "CPU resource request for the NGINX Ingress Controller"
  nullable    = true
  default     = null
}

// Memory resource request for the NGINX Ingress Controller
variable "nginx_ingress_controller_request_memory" {
  type        = string
  description = "Memory resource request for the NGINX Ingress Controller"
  nullable    = true
  default     = null
}

// CPU resource limit for the NGINX Ingress Controller (4x request)
variable "nginx_ingress_controller_limit_cpu" {
  type        = string
  description = "CPU resource limit for the NGINX Ingress Controller (4x request)"
  nullable    = true
  default     = null
}

// Memory resource limit for the NGINX Ingress Controller (4x request)
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

// CPU resource request for the NGINX Ingress default backend
variable "nginx_ingress_controller_default_backend_request_cpu" {
  type        = string
  description = "CPU resource request for the NGINX Ingress default backend"
  nullable    = true
  default     = null
}

// Memory resource request for the NGINX Ingress default backend
variable "nginx_ingress_controller_default_backend_request_memory" {
  type        = string
  description = "Memory resource request for the NGINX Ingress default backend"
  nullable    = true
  default     = null
}

// CPU resource limit for the NGINX Ingress default backend (4x request)
variable "nginx_ingress_controller_default_backend_limit_cpu" {
  type        = string
  description = "CPU resource limit for the NGINX Ingress default backend (4x request)"
  nullable    = true
  default     = null
}

// Memory resource limit for the NGINX Ingress default backend (4x request)
variable "nginx_ingress_controller_default_backend_limit_memory" {
  type        = string
  description = "Memory resource limit for the NGINX Ingress default backend (4x request)"
  nullable    = true
  default     = null
}
