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
// Stores the encrypted AES key used by Kani Coordinator and other services
// ======================================================
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

// ======================================================
// Secret: Encrypted JWT Secret
// Stores the encrypted JWT secret key used by Kani Coordinator and other services
// ======================================================
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

// ======================================================
// Secret: Privy App Secret Key
// Stores the Privy app secret key used by Kani Coordinator and other services
// ======================================================
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

// ======================================================
// Secret: Privy Signer Private Key
// Stores the Privy signer private key used by Kani Coordinator and other services
// ======================================================
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

// ======================================================
// Secret: Coin Market Cap API Key
// Stores the Coin Market Cap API key used by Kani Coordinator and other services
// ======================================================
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