// =========================
// Domain configuration variables
// =========================
// Defines the base domain and subdomain prefixes used
// to expose platform services via ingress and DNS.

variable "domain_name" {
  type        = string
  description = "Base domain name used for all public-facing services (e.g. example.com)"
}

// =========================
// Argo CD domain configuration
// =========================

variable "argo_cd_prefix" {
  type        = string
  description = "Subdomain prefix for the Argo CD server (combined with domain_name)"
  default     = "argo-cd"
}

// =========================
// Prometheus domain configuration
// =========================

variable "prometheus_prefix" {
  type        = string
  description = "Subdomain prefix for the Prometheus server (combined with domain_name)"
  default     = "prometheus"
}

// =========================
// API domain configuration
// =========================

variable "api_prefix" {
  type        = string
  description = "Subdomain prefix for the API server (combined with domain_name)"
  default     = "api"
}