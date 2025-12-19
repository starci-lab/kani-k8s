// =========================
// DigitalOcean authentication variables
// =========================

variable "digitalocean_token" {
  type        = string
  description = "API token used by Terraform to authenticate and manage resources in the DigitalOcean account"
  sensitive   = true
}

// =========================
// Cloudflare authentication variables
// =========================

variable "cloudflare_api_token" {
  type        = string
  description = "API token used by Terraform to authenticate and manage DNS and other resources in the Cloudflare account"
  sensitive   = true
}

// =========================
// GitHub SSH private key variables
// =========================

variable "argo_cd_git_ssh_private_key" {
  type        = string
  description = "SSH private key used by Terraform to authenticate and manage Argo CD Git repository"
  sensitive   = true
}

// =========================
// GCP project ID variables
// =========================
// Controls the GCP project ID used by External Secrets.
variable "gcp_project_id" {
  type        = string
  description = "GCP project ID"
  sensitive = true
}