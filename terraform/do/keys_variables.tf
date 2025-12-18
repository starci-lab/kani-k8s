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