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
// JWT salt variables
// =========================
// Controls the JWT salt used by Kani Interface.
variable "jwt_salt" {
  type        = string
  description = "JWT salt"
  sensitive = true
}

// =========================
// AES CBC salt variables
// =========================
// Controls the AES CBC salt used by Kani Interface.
variable "aes_cbc_salt" {
  type        = string
  description = "AES CBC salt"
  sensitive = true
}

// =========================
// Kani Interface Deployment Rollout Webhook Token variables
// =========================
// Controls the webhook token for Kani Interface Deployment Rollout.
variable "kani_interface_deployment_rollout_webhook_token" {
  type = string
  description = "Webhook token for Kani Interface Deployment Rollout"
  sensitive = true
}

// =========================
// Kani Coordinator Deployment Rollout Webhook Token variables
// =========================
// Controls the webhook token for Kani Coordinator Deployment Rollout.
variable "kani_coordinator_deployment_rollout_webhook_token" {
  type = string
  description = "Webhook token for Kani Coordinator Deployment Rollout"
  sensitive = true
}

// =========================
// Kani Observer Deployment Rollout Webhook Token variables
// =========================
// Controls the webhook token for Kani Observer Deployment Rollout.
variable "kani_observer_deployment_rollout_webhook_token" {
  type = string
  description = "Webhook token for Kani Observer Deployment Rollout"
  sensitive = true
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