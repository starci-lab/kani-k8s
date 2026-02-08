// =========================
// DigitalOcean authentication variables
// =========================

// API token used by Terraform to authenticate and manage resources in the DigitalOcean account
variable "digitalocean_token" {
  type        = string
  description = "API token used by Terraform to authenticate and manage resources in the DigitalOcean account"
  sensitive   = true
}

// =========================
// Cloudflare authentication variables
// =========================

// API token used by Terraform to authenticate and manage DNS and other resources in the Cloudflare account
variable "cloudflare_api_token" {
  type        = string
  description = "API token used by Terraform to authenticate and manage DNS and other resources in the Cloudflare account"
  sensitive   = true
}

// =========================
// GitHub SSH private key variables
// =========================

// SSH private key (base64-encoded) used by Argo CD to authenticate with the Git repository
variable "argo_cd_git_ssh_private_key" {
  type        = string
  description = "SSH private key used by Terraform to authenticate and manage Argo CD Git repository"
  sensitive   = true
}

// Decoded SSH private key for Argo CD Git repository authentication
locals {
  argo_cd_git_ssh_private_key_decoded = base64decode(var.argo_cd_git_ssh_private_key)
}

// =========================
// JWT salt variables
// =========================
// Salt used for JWT token generation (passed to Kani workloads).

// Salt value used for JWT token generation in Kani workloads
variable "jwt_salt" {
  type        = string
  description = "JWT salt"
  sensitive   = true
}

// =========================
// AES CBC salt variables
// =========================
// Salt used for AES-CBC encryption (passed to Kani workloads).

// Salt value used for AES-CBC encryption in Kani workloads
variable "aes_cbc_salt" {
  type        = string
  description = "AES CBC salt"
  sensitive   = true
}

// =========================
// Kani Interface Deployment Rollout Webhook Token variables
// =========================
// Webhook token used by job triggers for Kani Interface rollout.

// Webhook token used by job triggers to authenticate Kani Interface deployment rollout requests
variable "kani_interface_deployment_rollout_webhook_token" {
  type        = string
  description = "Webhook token for Kani Interface Deployment Rollout"
  sensitive   = true
}

// =========================
// Kani Coordinator Deployment Rollout Webhook Token variables
// =========================
// Webhook token used by job triggers for Kani Coordinator rollout.

// Webhook token used by job triggers to authenticate Kani Coordinator deployment rollout requests
variable "kani_coordinator_deployment_rollout_webhook_token" {
  type        = string
  description = "Webhook token for Kani Coordinator Deployment Rollout"
  sensitive   = true
}

// =========================
// Kani Observer Deployment Rollout Webhook Token variables
// =========================
// Webhook token used by job triggers for Kani Observer rollout.

// Webhook token used by job triggers to authenticate Kani Observer deployment rollout requests
variable "kani_observer_deployment_rollout_webhook_token" {
  type        = string
  description = "Webhook token for Kani Observer Deployment Rollout"
  sensitive   = true
}

// =========================
// GCP project ID variables
// =========================
// GCP project ID used by External Secrets / GCP integrations.

// GCP project ID used by External Secrets and other GCP integrations
variable "gcp_project_id" {
  type        = string
  description = "GCP project ID"
  sensitive   = true
}


// =========================
// Jenkins user variables
// =========================

// Username for Jenkins admin user
variable "jenkins_user" {
  type        = string
  description = "Username for Jenkins admin user"
  default     = "admin"
}

// Password for Jenkins admin user
variable "jenkins_password" {
  type        = string
  description = "Password for Jenkins admin user"
  sensitive   = true
}