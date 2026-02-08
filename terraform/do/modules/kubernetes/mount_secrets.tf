// =========================
// GCP Secret Accessor Service Account (External Secrets)
// =========================
resource "kubernetes_secret" "gcp_secret_accessor_sa" {
  metadata {
    name      = "gcp-secret-accessor-sa"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  // Terraform automatically base64-encodes values
  data = {
    data = var.gcp_secret_accessor_sa
  }

  type = "Opaque"
}

// =========================
// GCP Crypto Key Encrypt/Decrypt SA (Kani Coordinator)
// =========================
resource "kubernetes_secret" "gcp_crypto_key_ed_sa" {
  metadata {
    name      = "gcp-crypto-key-ed-sa"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  data = {
    data = var.gcp_crypto_key_ed_sa
  }

  type = "Opaque"
}

// =========================
// GCP Cloud KMS Crypto Operator SA
// =========================
resource "kubernetes_secret" "gcp_cloud_kms_crypto_operator_sa" {
  metadata {
    name      = "gcp-cloud-kms-crypto-operator-sa"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  data = {
    data = var.gcp_cloud_kms_crypto_operator_sa
  }

  type = "Opaque"
}

// =========================
// GCP Google Drive UD SA (Kani Coordinator)
// =========================
resource "kubernetes_secret" "gcp_google_drive_ud_sa" {
  metadata {
    name      = "gcp-google-drive-ud-sa"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  data = {
    data = var.gcp_google_drive_ud_sa
  }

  type = "Opaque"
}

// =========================
// Encrypted AES Key
// =========================
resource "kubernetes_secret" "encrypted_aes_key" {
  metadata {
    name      = "encrypted-aes-key"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  data = {
    data = var.encrypted_aes_key
  }

  type = "Opaque"
}

// =========================
// Encrypted JWT Secret Key
// =========================
resource "kubernetes_secret" "encrypted_jwt_secret_key" {
  metadata {
    name      = "encrypted-jwt-secret-key"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  data = {
    data = var.encrypted_jwt_secret_key
  }

  type = "Opaque"
}

// =========================
// Privy App Secret Key
// =========================
resource "kubernetes_secret" "privy_app_secret_key" {
  metadata {
    name      = "privy-app-secret-key"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  data = {
    data = var.privy_app_secret_key
  }

  type = "Opaque"
}

// =========================
// Privy Signer Private Key
// =========================
resource "kubernetes_secret" "privy_signer_private_key" {
  metadata {
    name      = "privy-signer-private-key"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  data = {
    data = var.privy_signer_private_key
  }

  type = "Opaque"
}

// =========================
// Coin Market Cap API Key
// =========================
resource "kubernetes_secret" "coin_market_cap_api_key" {
  metadata {
    name      = "coin-market-cap-api-key"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  data = {
    data = var.coin_market_cap_api_key
  }
  type = "Opaque"
}