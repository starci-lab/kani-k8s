// =========================
// cert-manager Helm release
// =========================
// Deploys cert-manager using the Bitnami Helm chart.
// cert-manager automates the management and issuance of TLS certificates from various issuing sources.
// Resource requests and limits for each cert-manager component are configured via a templated values file.
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = kubernetes_namespace.cert_manager.metadata[0].name
  create_namespace = true

  // Bitnami cert-manager chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/cert-manager"

  // Render Helm values from a Terraform template and inject resource variables
  values = [
    templatefile("${path.module}/yamls/cert-manager.yaml", {
      // Installation and replica counts
      install_crds              = var.cert_manager_install_crds
      controller_replica_count = var.cert_manager_controller_replica_count
      webhook_replica_count    = var.cert_manager_webhook_replica_count
      cainjector_replica_count = var.cert_manager_cainjector_replica_count

      // Core component resources
      cert_manager_request_cpu    = local.cert_manager.cert_manager.request_cpu
      cert_manager_request_memory = local.cert_manager.cert_manager.request_memory
      cert_manager_limit_cpu      = local.cert_manager.cert_manager.limit_cpu
      cert_manager_limit_memory   = local.cert_manager.cert_manager.limit_memory

      // Webhook resources
      webhook_request_cpu    = local.cert_manager.webhook.request_cpu
      webhook_request_memory = local.cert_manager.webhook.request_memory
      webhook_limit_cpu      = local.cert_manager.webhook.limit_cpu
      webhook_limit_memory   = local.cert_manager.webhook.limit_memory

      // CA injector resources
      cainjector_request_cpu    = local.cert_manager.cainjector.request_cpu
      cainjector_request_memory = local.cert_manager.cainjector.request_memory
      cainjector_limit_cpu      = local.cert_manager.cainjector.limit_cpu
      cainjector_limit_memory   = local.cert_manager.cainjector.limit_memory

      // Controller resources
      controller_request_cpu    = local.cert_manager.controller.request_cpu
      controller_request_memory = local.cert_manager.controller.request_memory
      controller_limit_cpu      = local.cert_manager.controller.limit_cpu
      controller_limit_memory   = local.cert_manager.controller.limit_memory
    })
  ]

  // Ensure the cert-manager namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.cert_manager
  ]
}
