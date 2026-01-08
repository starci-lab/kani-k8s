// =========================
// Domain variables
// =========================

variable "domain_name" {
  type        = string
  description = "Domain name for the Kubernetes cluster"
  default     = "kanibot.xyz"
}

variable "prefix_domain_name" {
  type        = string
  description = "Prefix for the domain name"
  default     = "none"
}