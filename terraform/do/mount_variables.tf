// =========================
// Encrypted secret inputs (mounted / decrypted by workloads)
// =========================

variable "encrypted_aes_key" {
  type        = string
  description = "Encrypted AES key"
  sensitive = true
}

variable "encrypted_jwt_secret_key" {
  type        = string
  description = "Encrypted JWT secret"
  sensitive = true
}

variable "app_secret_version" {
  type        = number
  description = "App secret version"
  default     = 2
}

variable "rpcs_secret_version" {
  type        = number
  description = "RPCs secret version"
  default     = 4
}

// =========================
// GCP service account inputs (base64-encoded JSON)
// =========================

variable "gcp_secret_accessor_sa" {
  type        = string
  description = "GCP secret accessor service account"
  sensitive = true
}

variable "gcp_crypto_key_ed_sa" {
  type        = string
  description = "GCP crypto key encryptor/decryptor service account"
  sensitive = true
}

variable "gcp_cloud_kms_crypto_operator_sa" {
  type        = string
  description = "GCP Cloud KMS crypto operator service account"
  sensitive = true
}

variable "gcp_google_drive_ud_sa" {
  type        = string
  description = "GCP Google Drive UD service account"
  sensitive = true
}

// =========================
// Decoded service account JSON (locals)
// =========================

locals {
  gcp_secret_accessor_sa_decoded = base64decode(var.gcp_secret_accessor_sa)
  gcp_crypto_key_ed_sa_decoded = base64decode(var.gcp_crypto_key_ed_sa)
  gcp_cloud_kms_crypto_operator_sa_decoded = base64decode(var.gcp_cloud_kms_crypto_operator_sa)
  gcp_google_drive_ud_sa_decoded = base64decode(var.gcp_google_drive_ud_sa)
}