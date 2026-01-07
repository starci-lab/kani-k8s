// =========================
// Namespaces
// =========================
// ======================================================
// External Secrets Namespace
// ======================================================
resource "kubernetes_namespace" "gcp_secrets" {
  metadata {
    name = "gcp-secrets"
  }
}
// ======================================================
// GCP Service Account Secret
// ======================================================
// Creates a secret for the GCP service account used by External Secrets.
// ======================================================
resource "kubernetes_secret" "gcp_secret_accessor" {
  metadata {
    name      = "gcp-secret-accessor"
    namespace = kubernetes_namespace.gcp_secrets.metadata[0].name
  }

  data = {
    "secret-access-credentials" = var.gcp_secret_accessor_sa
  }

  type = "Opaque"
}

// ======================================================
// GCP Crypto Key ED Service Account Secret
// ======================================================
// Creates a secret for the GCP crypto key ED service account used by Kani Coordinator.
// ======================================================
resource "kubernetes_secret" "gcp_crypto_key_ed" {
  metadata {
    name      = "gcp-crypto-key-ed"
    namespace = kubernetes_namespace.gcp_secrets.metadata[0].name
  }
}

// ======================================================
// GCP Cloud KMS Crypto Operator Service Account Secret
// ======================================================
// Creates a secret for the GCP cloud KMS crypto operator service account used by Kani Coordinator.
// ======================================================
resource "kubernetes_secret" "gcp_cloud_kms_crypto_operator" {
  metadata {
    name      = "gcp-cloud-kms-crypto-operator"
    namespace = kubernetes_namespace.gcp_secrets.metadata[0].name
  }
}

// ======================================================
// GCP Google Drive UD Service Account Secret
// ======================================================
// Creates a secret for the GCP Google Drive UD service account used by Kani Coordinator.
// ======================================================
resource "kubernetes_secret" "gcp_google_drive_ud" {
  metadata {
    name      = "gcp-google-drive-ud"
    namespace = kubernetes_namespace.gcp_secrets.metadata[0].name
  }
}

// ======================================================
// Encrypted AES Secret
// ======================================================
// Creates a secret for the encrypted AES key used by Kani Coordinator.
// ======================================================
resource "kubernetes_secret" "encrypted_aes" {
  metadata {
    name      = "encrypted-aes"
    namespace = kubernetes_namespace.gcp_secrets.metadata[0].name
  }
}

// ======================================================
// Encrypted JWT Secret
// ======================================================
// Creates a secret for the encrypted JWT secret used by Kani Coordinator.
// ======================================================
resource "kubernetes_secret" "encrypted_jwt_secret" {
  metadata {
    name      = "encrypted-jwt-secret"
    namespace = kubernetes_namespace.gcp_secrets.metadata[0].name
  }
}