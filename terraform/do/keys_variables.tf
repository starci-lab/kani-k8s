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

locals {
  argo_cd_git_ssh_private_key_decoded = base64decode(var.argo_cd_git_ssh_private_key)
}

// =========================
// JWT salt variables
// =========================
// Salt used for JWT token generation (passed to Kani workloads).

variable "jwt_salt" {
  type        = string
  description = "JWT salt"
  sensitive   = true
}

// =========================
// AES CBC salt variables
// =========================
// Salt used for AES-CBC encryption (passed to Kani workloads).

variable "aes_cbc_salt" {
  type        = string
  description = "AES CBC salt"
  sensitive   = true
}

// =========================
// Kani Interface Deployment Rollout Webhook Token variables
// =========================
// Webhook token used by Jenkins job triggers for Kani Interface rollout.

variable "kani_interface_deployment_rollout_webhook_token" {
  type        = string
  description = "Webhook token for Kani Interface Deployment Rollout"
  sensitive   = true
}

// =========================
// Kani Coordinator Deployment Rollout Webhook Token variables
// =========================
// Webhook token used by Jenkins job triggers for Kani Coordinator rollout.

variable "kani_coordinator_deployment_rollout_webhook_token" {
  type        = string
  description = "Webhook token for Kani Coordinator Deployment Rollout"
  sensitive   = true
}

// =========================
// Kani Observer Deployment Rollout Webhook Token variables
// =========================
// Webhook token used by Jenkins job triggers for Kani Observer rollout.

variable "kani_observer_deployment_rollout_webhook_token" {
  type        = string
  description = "Webhook token for Kani Observer Deployment Rollout"
  sensitive   = true
}

// =========================
// GCP project ID variables
// =========================
// GCP project ID used by External Secrets / GCP integrations.

variable "gcp_project_id" {
  type        = string
  description = "GCP project ID"
  sensitive   = true
}