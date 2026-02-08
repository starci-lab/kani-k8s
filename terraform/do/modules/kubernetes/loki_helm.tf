// =========================
// Loki Helm release
// =========================
// Deploys Grafana Loki using the Bitnami Helm chart.
// Configuration is provided via a templated values file,
// including resource allocation, persistence, and node scheduling.
resource "helm_release" "loki" {
  name      = local.loki.name
  namespace = kubernetes_namespace.loki.metadata[0].name

  // Bitnami Grafana Loki chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/grafana-loki"

  // Render Helm values from a Terraform template and inject variables
  values = [
    templatefile("${path.module}/yamls/loki.yaml", {
      // Node scheduling
      node_pool_label = var.kubernetes_primary_node_pool_name
      // Gateway configuration
      gateway_replica_count   = var.loki_gateway_replica_count
      gateway_request_cpu    = local.loki.gateway.request_cpu
      gateway_request_memory = local.loki.gateway.request_memory
      gateway_limit_cpu      = local.loki.gateway.limit_cpu
      gateway_limit_memory   = local.loki.gateway.limit_memory
      // Compactor configuration
      compactor_replica_count     = var.loki_compactor_replica_count
      compactor_persistence_size  = var.loki_compactor_persistence_size
      compactor_request_cpu       = local.loki.compactor.request_cpu
      compactor_request_memory    = local.loki.compactor.request_memory
      compactor_limit_cpu         = local.loki.compactor.limit_cpu
      compactor_limit_memory      = local.loki.compactor.limit_memory
      // Other components
      distributor_replica_count = var.loki_distributor_replica_count
      ingester_replica_count    = var.loki_ingester_replica_count
      ingester_persistence_size = var.loki_ingester_persistence_size
      querier_replica_count     = var.loki_querier_replica_count
      querier_persistence_size  = var.loki_querier_persistence_size
      query_frontend_replica_count = var.loki_query_frontend_replica_count
    })
  ]

  // Ensure the Loki namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.loki
  ]
}
