// =========================
// Encrypted secret inputs
// =========================
// These are encrypted payloads (e.g., produced by a KMS workflow) that are later
// mounted into workloads via Kubernetes Secrets.

variable "encrypted_aes_key" {
  type        = string
  description = "Encrypted AES key"
  sensitive = true
}

variable "encrypted_jwt_secret_key" {
  type        = string
  description = "Encrypted JWT secret key"
  sensitive = true
}

// =========================
// GCP service account inputs (base64-encoded JSON)
// =========================
// These values are expected to be base64-encoded service account JSON strings
// and are stored as Kubernetes Secrets for use by workloads/operators.

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