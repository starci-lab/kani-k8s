// =========================
// ExternalSecret instances (GCP → Kubernetes)
// =========================
// Defines which GCP secrets are synced into the kani namespace.
locals {
  external_secrets_instances = {
    app = {
      name               = "app"
      target_secret_name = "app"
      target_secret_key  = "data"
      gcp_secret_name    = "app"
      version            = var.app_secret_version
    }
    rpcs = {
      name               = "rpcs"
      target_secret_name = "rpcs"
      target_secret_key  = "data"
      gcp_secret_name    = "rpcs"
      version            = var.rpcs_secret_version
    }
  }
}

// =========================
// ExternalSecret resources
// =========================
resource "kubectl_manifest" "external_secret" {
  for_each = local.external_secrets_instances
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