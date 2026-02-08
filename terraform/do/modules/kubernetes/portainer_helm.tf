// =========================
// Portainer Helm release
// =========================
// Deploys Portainer using the official Portainer Helm chart.
// All configuration is injected via a Terraform-rendered values file.
resource "helm_release" "portainer" {
  name      = local.portainer.name
  namespace = kubernetes_namespace.portainer.metadata[0].name

  // Official Portainer Helm chart
  repository = "https://portainer.github.io/k8s/"
  chart      = "portainer"

  // Render Helm values from template and inject Terraform variables
  values = [
    templatefile("${path.module}/yamls/portainer.yaml", {
      // Replica count
      replica_count = var.portainer_replica_count
      // Portainer server resources
      request_cpu    = local.portainer.portainer.request_cpu
      request_memory = local.portainer.portainer.request_memory
      limit_cpu      = local.portainer.portainer.limit_cpu
      limit_memory   = local.portainer.portainer.limit_memory
      persistence_size = var.portainer_persistence_size
      // Node scheduling
      node_pool_label = var.kubernetes_primary_node_pool_name
    })
  ]

  // Ensure the Portainer namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.portainer
  ]
}
