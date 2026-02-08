// =========================
// External Secrets Helm release
// =========================
// Deploys External Secrets using the official External Secrets Helm chart.
// External Secrets Operator integrates external secret management systems (e.g., GCP Secret Manager, AWS Secrets Manager)
// with Kubernetes, automatically syncing secrets into Kubernetes Secret resources.
// All configuration is injected via a Terraform-rendered values file.
resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace = kubernetes_namespace.external_secrets.metadata[0].name

  values = [
    templatefile("${path.module}/yamls/external-secrets.yaml", {
      // Replica counts
      operator_replica_count        = var.external_secrets_operator_replica_count
      webhook_replica_count         = var.external_secrets_webhook_replica_count
      cert_controller_replica_count = var.external_secrets_cert_controller_replica_count

      // Operator resources
      request_cpu    = local.external_secrets.external_secrets.request_cpu
      request_memory = local.external_secrets.external_secrets.request_memory
      limit_cpu      = local.external_secrets.external_secrets.limit_cpu
      limit_memory   = local.external_secrets.external_secrets.limit_memory

      // Webhook resources
      webhook_request_cpu    = local.external_secrets.webhook.request_cpu
      webhook_request_memory = local.external_secrets.webhook.request_memory
      webhook_limit_cpu      = local.external_secrets.webhook.limit_cpu
      webhook_limit_memory   = local.external_secrets.webhook.limit_memory

      // Cert controller resources
      cert_controller_request_cpu    = local.external_secrets.cert_controller.request_cpu
      cert_controller_request_memory = local.external_secrets.cert_controller.request_memory
      cert_controller_limit_cpu      = local.external_secrets.cert_controller.limit_cpu
      cert_controller_limit_memory   = local.external_secrets.cert_controller.limit_memory
    })
  ]
}
