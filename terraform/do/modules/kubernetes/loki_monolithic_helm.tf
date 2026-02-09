// =========================
// Loki Monolithic Helm release
// =========================
// Deploys Grafana Loki in SingleBinary (monolithic) mode using the Grafana Helm chart.
// Configuration is provided via a templated values file (loki-monilithic.yaml),
// including resource allocation, persistence, and node scheduling.
resource "helm_release" "loki_monolithic" {
  name      = local.loki_monolithic.name
  namespace = kubernetes_namespace.loki.metadata[0].name

  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"

  values = [
    templatefile("${path.module}/yamls/loki-monilithic.yaml", {
      // Node scheduling
      node_pool_label = var.kubernetes_primary_node_pool_name
      // Loki monolithic configuration
      replication_factor = var.loki_monolithic_replication_factor
      // Single-binary resources
      request_cpu    = local.loki_monolithic.single_binary.request_cpu
      request_memory = local.loki_monolithic.single_binary.request_memory
      limit_cpu      = local.loki_monolithic.single_binary.limit_cpu
      limit_memory   = local.loki_monolithic.single_binary.limit_memory
      // Persistence
      persistence_size = var.loki_monolithic_persistence_size
    })
  ]

  depends_on = [
    kubernetes_namespace.loki
  ]
}
