// =========================
// Namespace for cert-manager
// =========================
// Creates a dedicated namespace for cert-manager components and resources.
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace.
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// cert-manager Helm release
// =========================
// Deploys cert-manager using the Bitnami Helm chart.
// Resource requests and limits for each cert-manager component
// are configured via a templated values file.
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = kubernetes_namespace.cert_manager.metadata[0].name
  create_namespace = true

  // Bitnami cert-manager chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/cert-manager"

  // Render Helm values from a Terraform template and inject resource variables
  values = [
    templatefile("${path.module}/yamls/cert-manager.yaml", {
      // =========================
      // Replica counts
      // =========================
      controller_replica_count = var.cert_manager_controller_replica_count
      webhook_replica_count    = var.cert_manager_webhook_replica_count
      cainjector_replica_count = var.cert_manager_cainjector_replica_count
      // =========================
      // cert-manager core component resources
      // =========================
      install_crds                = var.cert_manager_install_crds
      cert_manager_request_cpu    = local.cert_manager.cert_manager.request_cpu
      cert_manager_request_memory = local.cert_manager.cert_manager.request_memory
      cert_manager_limit_cpu      = local.cert_manager.cert_manager.limit_cpu
      cert_manager_limit_memory   = local.cert_manager.cert_manager.limit_memory

      // =========================
      // cert-manager webhook resources
      // =========================
      webhook_request_cpu    = local.cert_manager.webhook.request_cpu
      webhook_request_memory = local.cert_manager.webhook.request_memory
      webhook_limit_cpu      = local.cert_manager.webhook.limit_cpu
      webhook_limit_memory   = local.cert_manager.webhook.limit_memory

      // =========================
      // cert-manager CA injector resources
      // =========================
      cainjector_request_cpu    = local.cert_manager.cainjector.request_cpu
      cainjector_request_memory = local.cert_manager.cainjector.request_memory
      cainjector_limit_cpu      = local.cert_manager.cainjector.limit_cpu
      cainjector_limit_memory   = local.cert_manager.cainjector.limit_memory

      // =========================
      // cert-manager controller resources
      // =========================
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

// =========================
// cert-manager ClusterIssuer (Let's Encrypt - Production)
// =========================
// Creates a ClusterIssuer used by cert-manager to request TLS certificates
// from Let's Encrypt using the HTTP-01 challenge via NGINX Ingress.
resource "kubectl_manifest" "cluster_issuer_letsencrypt_prod" {
  // Ensure cert-manager is fully installed before creating the ClusterIssuer
  depends_on = [helm_release.cert_manager]
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ${var.cert_manager_cluster_issuer_name}
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: ${var.cert_manager_email}
    privateKeySecretRef:
      name: ${var.cert_manager_cluster_issuer_name}
    solvers:
      - http01:
          ingress:
            class: nginx
YAML
}