variable "encrypted_aes" {
  type        = string
  description = "Encrypted AES key"
  sensitive = true
}

variable "encrypted_jwt_secret" {
  type        = string
  description = "Encrypted JWT secret"
  sensitive = true
}

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