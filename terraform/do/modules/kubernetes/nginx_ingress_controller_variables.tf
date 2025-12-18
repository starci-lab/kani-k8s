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
  default     = "64m"
}

variable "nginx_ingress_controller_request_memory" {
  type        = string
  description = "Memory resource request for the NGINX Ingress Controller"
  default     = "128Mi"
}

variable "nginx_ingress_controller_limit_cpu" {
  type        = string
  description = "CPU resource limit for the NGINX Ingress Controller (4x request)"
  default     = "256m"
}

variable "nginx_ingress_controller_limit_memory" {
  type        = string
  description = "Memory resource limit for the NGINX Ingress Controller (4x request)"
  default     = "512Mi"
}

// =========================
// NGINX Ingress default backend variables
// =========================
// Controls resource allocation for the default backend,
// which serves fallback responses (e.g. 404) when no ingress rule matches.

variable "nginx_ingress_controller_default_backend_request_cpu" {
  type        = string
  description = "CPU resource request for the NGINX Ingress default backend"
  default     = "32m"
}

variable "nginx_ingress_controller_default_backend_request_memory" {
  type        = string
  description = "Memory resource request for the NGINX Ingress default backend"
  default     = "64Mi"
}

variable "nginx_ingress_controller_default_backend_limit_cpu" {
  type        = string
  description = "CPU resource limit for the NGINX Ingress default backend (4x request)"
  default     = "128m"
}

variable "nginx_ingress_controller_default_backend_limit_memory" {
  type        = string
  description = "Memory resource limit for the NGINX Ingress default backend (4x request)"
  default     = "256Mi"
}