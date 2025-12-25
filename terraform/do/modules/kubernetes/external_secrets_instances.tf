// ======================================================
// External Secrets Instances Configuration
// ------------------------------------------------------
// Defines the ExternalSecret resources that sync secrets
// from Google Cloud Secret Manager to Kubernetes secrets.
//
// Each ExternalSecret automatically fetches secrets from GCP
// and creates/updates corresponding Kubernetes secrets in
// the target namespace.
// ======================================================

locals {
  // Map of ExternalSecret definitions
  // Each entry defines:
  // - name: The ExternalSecret resource name
  // - target_secret_name: The Kubernetes secret name to create
  // - target_secret_key: The key name in the Kubernetes secret
  // - gcp_secret_name: The secret name in Google Cloud Secret Manager
  external_secrets_instances = {
    aes = {
      name               = "aes"
      target_secret_name = "aes"
      target_secret_key  = "data"
      gcp_secret_name    = "aes"
      version            = 1
    }
    jwt_secret = {
      name               = "jwt-secret"
      target_secret_name = "jwt-secret"
      target_secret_key  = "data"
      gcp_secret_name    = "jwt-secret"
      version            = 1
    }
    crypto-key-ed-sa = {
      name               = "crypto-key-ed-sa"
      target_secret_name = "crypto-key-ed-sa"
      target_secret_key  = "data"
      gcp_secret_name    = "crypto-key-ed-sa"
      version            = 1
    }
    smtp = {
      name               = "smtp"
      target_secret_name = "smtp"
      target_secret_key  = "data"
      gcp_secret_name    = "smtp"
      version            = 2
    }
    api-keys = {
      name               = "api-keys"
      target_secret_name = "api-keys"
      target_secret_key  = "data"
      gcp_secret_name    = "api-keys"
      version            = 1
    }
    rpcs = {
      name               = "rpcs"
      target_secret_name = "rpcs"
      target_secret_key  = "data"
      gcp_secret_name    = "rpcs"
      version            = 3
    }
  }
}

// ======================================================
// External Secrets Resources
// ------------------------------------------------------
// Creates ExternalSecret resources that sync secrets from
// Google Cloud Secret Manager to Kubernetes secrets.
//
// These resources use the ClusterSecretStore for authentication
// and automatically refresh when the source secret changes.
// ======================================================
resource "kubectl_manifest" "external_secret" {
  for_each = local.external_secrets_instances

  // Ensure ClusterSecretStore is ready before creating ExternalSecrets
  depends_on = [
    kubectl_manifest.gcp_cluster_secret_store
  ]

  yaml_body = <<YAML
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: ${each.value.name}
  namespace: ${kubernetes_namespace.kani.metadata[0].name}
spec:
  refreshPolicy: OnChange

  secretStoreRef:
    name: ${local.gcp_cluster_secret_store.name}
    kind: ClusterSecretStore

  target:
    name: ${each.value.target_secret_name}
    creationPolicy: Owner

  data:
    - secretKey: ${each.value.target_secret_key}
      remoteRef:
        key: ${each.value.gcp_secret_name}
        version: "${tostring(each.value.version)}"
YAML
}

