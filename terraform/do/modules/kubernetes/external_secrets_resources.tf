// =========================
// Namespace for External Secrets
// =========================
// Creates a dedicated namespace to isolate External Secrets
// and its related resources from application workloads.
// External Secrets Operator integrates external secret management systems with Kubernetes.
resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// GCP ClusterSecretStore
// =========================
// Allows External Secrets Operator to pull secrets from Google Cloud Secret Manager.
// Authentication uses a Kubernetes Secret containing the GCP Service Account key.
locals {
  gcp_cluster_secret_store = {
    name = "gcp-secret-store"
  }
}

resource "kubectl_manifest" "gcp_cluster_secret_store" {
  // Ensure External Secrets Operator is installed before creating SecretStore
  depends_on = [
    helm_release.external_secrets
  ]
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: ${local.gcp_cluster_secret_store.name}
spec:
  provider:
    gcpsm:
      auth:
        secretRef:
          secretAccessKeySecretRef:
            name: ${kubernetes_secret.gcp_secret_accessor_sa.metadata[0].name}
            key: data
            namespace: ${kubernetes_namespace.kani.metadata[0].name}
      projectID: "${var.gcp_project_id}"
      secretVersionSelectionPolicy: LatestOrFetch
status:
  conditions:
  - type: Ready
    status: "False"
    reason: "ConfigError"
    message: "SecretStore validation failed"
    lastTransitionTime: "2019-08-12T12:33:02Z"
YAML
}

// =========================
// ExternalSecret resources
// =========================
// Creates ExternalSecret resources that sync GCP Secret Manager secrets into Kubernetes Secrets.
// Each ExternalSecret references a GCP secret and creates a corresponding Kubernetes Secret
// in the kani namespace when the GCP secret changes.
resource "kubectl_manifest" "external_secret" {
  for_each = local.external_secrets.instances
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