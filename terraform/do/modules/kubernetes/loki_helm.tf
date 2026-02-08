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
      // Loki configuration
      retention_period = var.loki_retention_period
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
      // Distributor configuration
      distributor_replica_count   = var.loki_distributor_replica_count
      distributor_request_cpu      = local.loki.distributor.request_cpu
      distributor_request_memory   = local.loki.distributor.request_memory
      distributor_limit_cpu        = local.loki.distributor.limit_cpu
      distributor_limit_memory     = local.loki.distributor.limit_memory
      // Ingester configuration
      ingester_replica_count       = var.loki_ingester_replica_count
      ingester_persistence_size    = var.loki_ingester_persistence_size
      ingester_request_cpu         = local.loki.ingester.request_cpu
      ingester_request_memory      = local.loki.ingester.request_memory
      ingester_limit_cpu           = local.loki.ingester.limit_cpu
      ingester_limit_memory        = local.loki.ingester.limit_memory
      // Querier configuration
      querier_replica_count        = var.loki_querier_replica_count
      querier_persistence_size     = var.loki_querier_persistence_size
      querier_request_cpu          = local.loki.querier.request_cpu
      querier_request_memory       = local.loki.querier.request_memory
      querier_limit_cpu            = local.loki.querier.limit_cpu
      querier_limit_memory         = local.loki.querier.limit_memory
      // Query Frontend configuration
      query_frontend_replica_count = var.loki_query_frontend_replica_count
      query_frontend_request_cpu   = local.loki.query_frontend.request_cpu
      query_frontend_request_memory = local.loki.query_frontend.request_memory
      query_frontend_limit_cpu     = local.loki.query_frontend.limit_cpu
      query_frontend_limit_memory  = local.loki.query_frontend.limit_memory
    })
  ]

  // Ensure the Loki namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.loki
  ]
}
