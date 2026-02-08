// =========================
// Namespace for External Secrets
// =========================
// Creates a dedicated namespace to isolate External Secrets
// and its related resources from application workloads.
resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// External Secrets Helm release
// =========================
// Deploys External Secrets using the official External Secrets Helm chart.
// All configuration is injected via a Terraform-rendered values file.
resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace = kubernetes_namespace.external_secrets.metadata[0].name

  values = [
    templatefile("${path.module}/yamls/external-secrets.yaml", {
      // =========================
      // Replica counts
      // =========================
      operator_replica_count        = var.external_secrets_operator_replica_count
      webhook_replica_count         = var.external_secrets_webhook_replica_count
      cert_controller_replica_count = var.external_secrets_cert_controller_replica_count
      // =========================
      // External Secrets resources
      // =========================
      request_cpu = local.external_secrets.external_secrets.request_cpu
      request_memory = local.external_secrets.external_secrets.request_memory
      limit_cpu = local.external_secrets.external_secrets.limit_cpu
      limit_memory = local.external_secrets.external_secrets.limit_memory
      // =========================
      // Webhook resources
      // =========================
      webhook_request_cpu = local.external_secrets.webhook.request_cpu
      webhook_request_memory = local.external_secrets.webhook.request_memory
      webhook_limit_cpu = local.external_secrets.webhook.limit_cpu
      webhook_limit_memory = local.external_secrets.webhook.limit_memory
      // =========================
      // Cert Controller resources
      // =========================
      cert_controller_request_cpu = local.external_secrets.cert_controller.request_cpu
      cert_controller_request_memory = local.external_secrets.cert_controller.request_memory
      cert_controller_limit_cpu = local.external_secrets.cert_controller.limit_cpu
      cert_controller_limit_memory = local.external_secrets.cert_controller.limit_memory
    })
  ]
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