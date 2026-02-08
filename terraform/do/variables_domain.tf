// =========================
// Domain variables
// =========================
// Base domain name used for constructing subdomain names for services
// (e.g., api.dev.kanibot.xyz, grafana.dev.kanibot.xyz).

// Base domain name for the Kubernetes cluster and services
variable "domain_name" {
  type        = string
  description = "Domain name for the Kubernetes cluster"
  default     = "kanibot.xyz"
}

// Prefix prepended to domain names to create environment-specific subdomains
variable "prefix_domain_name" {
  type        = string
  description = "Prefix for the domain name"
  default     = "dev"
}
