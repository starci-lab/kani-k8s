// =========================
// Encrypted secret inputs (mounted / decrypted by workloads)
// =========================

// Encrypted AES key that will be mounted into workloads and decrypted at runtime
variable "encrypted_aes_key" {
  type        = string
  description = "Encrypted AES key"
  sensitive   = true
}

// Encrypted JWT secret key that will be mounted into workloads and decrypted at runtime
variable "encrypted_jwt_secret_key" {
  type        = string
  description = "Encrypted JWT secret"
  sensitive   = true
}

// Version number of the app secret stored in GCP Secret Manager
variable "app_secret_version" {
  type        = number
  description = "App secret version"
  default     = 2
}

// Version number of the RPCs secret stored in GCP Secret Manager
variable "rpcs_secret_version" {
  type        = number
  description = "RPCs secret version"
  default     = 4
}

// =========================
// GCP service account inputs (base64-encoded JSON)
// =========================

// GCP service account JSON (base64-encoded) used by External Secrets to access GCP Secret Manager
variable "gcp_secret_accessor_sa" {
  type        = string
  description = "GCP secret accessor service account"
  sensitive   = true
}

// GCP service account JSON (base64-encoded) used for encrypting and decrypting data with Cloud KMS
variable "gcp_crypto_key_ed_sa" {
  type        = string
  description = "GCP crypto key encryptor/decryptor service account"
  sensitive   = true
}

// GCP service account JSON (base64-encoded) used by Cloud KMS crypto operator
variable "gcp_cloud_kms_crypto_operator_sa" {
  type        = string
  description = "GCP Cloud KMS crypto operator service account"
  sensitive   = true
}

// GCP service account JSON (base64-encoded) used for Google Drive user data access
variable "gcp_google_drive_ud_sa" {
  type        = string
  description = "GCP Google Drive UD service account"
  sensitive   = true
}

// Privy app secret key used for authentication with Privy services
variable "privy_app_secret_key" {
  type        = string
  description = "Privy app secret key"
  sensitive   = true
}

// Privy signer private key used for signing requests to Privy services
variable "privy_signer_private_key" {
  type        = string
  description = "Privy signer private key"
  sensitive   = true
}

// Coin Market Cap API key used for fetching cryptocurrency market data
variable "coin_market_cap_api_key" {
  type        = string
  description = "Coin Market Cap API key"
  sensitive   = true
}

// =========================
// Decoded service account JSON (locals)
// =========================

// Decoded GCP service account JSON strings for use in Kubernetes secrets
locals {
  gcp_secret_accessor_sa_decoded         = base64decode(var.gcp_secret_accessor_sa)
  gcp_crypto_key_ed_sa_decoded           = base64decode(var.gcp_crypto_key_ed_sa)
  gcp_cloud_kms_crypto_operator_sa_decoded = base64decode(var.gcp_cloud_kms_crypto_operator_sa)
  gcp_google_drive_ud_sa_decoded         = base64decode(var.gcp_google_drive_ud_sa)
}
