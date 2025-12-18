// =========================
// Domain variables
// =========================
variable "domain_name" {
  type        = string
  description = "Domain name for the Kubernetes cluster"
  default     = "kanibot.xyz"
}