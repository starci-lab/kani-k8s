// ======================================================
// Secret: GCP Secret Accessor Service Account
// Used by External Secrets to access GCP Secret Manager
// ======================================================
resource "kubernetes_secret" "gcp_secret_accessor" {
  metadata {
    name      = "gcp-secret-accessor"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  // Terraform automatically base64-encodes values
  data = {
    data = var.gcp_secret_accessor_sa
  }

  type = "Opaque"
}

// ======================================================
// Secret: GCP Crypto Key Encrypt/Decrypt Service Account
// Used by Kani Coordinator for encryption/decryption
// ======================================================
resource "kubernetes_secret" "gcp_crypto_key_ed" {
  metadata {
    name      = "gcp-crypto-key-ed"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  data = {
    data = var.gcp_crypto_key_ed_sa
  }

  type = "Opaque"
}

// ======================================================
// Secret: GCP Cloud KMS Crypto Operator Service Account
// Used for Cloud KMS crypto operations
// ======================================================
resource "kubernetes_secret" "gcp_cloud_kms_crypto_operator" {
  metadata {
    name      = "gcp-cloud-kms-crypto-operator"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  data = {
    data = var.gcp_cloud_kms_crypto_operator_sa
  }

  type = "Opaque"
}

// ======================================================
// Secret: GCP Google Drive UD Service Account
// Used by Kani Coordinator for Google Drive operations
// ======================================================
resource "kubernetes_secret" "gcp_google_drive_ud" {
  metadata {
    name      = "gcp-google-drive-ud"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  data = {
    data = var.gcp_google_drive_ud_sa
  }

  type = "Opaque"
}

// ======================================================
// Secret: Encrypted AES Key
// Stores the encrypted AES key used by Kani Coordinator
// ======================================================
resource "kubernetes_secret" "encrypted_aes" {
  metadata {
    name      = "encrypted-aes"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  data = {
    data = var.encrypted_aes
  }

  type = "Opaque"
}

// ======================================================
// Secret: Encrypted JWT Secret
// Stores the encrypted JWT secret used by Kani Coordinator
// ======================================================
resource "kubernetes_secret" "encrypted_jwt_secret" {
  metadata {
    name      = "encrypted-jwt-secret"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  data = {
    data = var.encrypted_jwt_secret
  }

  type = "Opaque"
}