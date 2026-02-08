// =========================
// Namespace for Loki
// =========================
resource "kubernetes_namespace" "loki" {
  metadata {
    name = "loki"
  }

  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// Loki local identifiers
// =========================
locals {
  loki_name                   = "loki"
  loki_gateway_service_name   = "loki-gateway"
}

// =========================
// Loki Helm release
// =========================
resource "helm_release" "loki" {
  name      = local.loki_name
  namespace = kubernetes_namespace.loki.metadata[0].name

  chart = "oci://registry-1.docker.io/bitnamicharts/grafana-loki"

  values = [
    templatefile("${path.module}/yamls/loki.yaml", {
      node_pool_label = var.kubernetes_primary_node_pool_name

      gateway_replica_count   = var.loki_gateway_replica_count
      gateway_request_cpu    = local.loki.gateway.request_cpu
      gateway_request_memory = local.loki.gateway.request_memory
      gateway_limit_cpu      = local.loki.gateway.limit_cpu
      gateway_limit_memory   = local.loki.gateway.limit_memory

      compactor_replica_count     = var.loki_compactor_replica_count
      compactor_persistence_size  = var.loki_compactor_persistence_size
      compactor_request_cpu       = local.loki.compactor.request_cpu
      compactor_request_memory    = local.loki.compactor.request_memory
      compactor_limit_cpu         = local.loki.compactor.limit_cpu
      compactor_limit_memory      = local.loki.compactor.limit_memory

      distributor_replica_count = var.loki_distributor_replica_count
      ingester_replica_count    = var.loki_ingester_replica_count
      ingester_persistence_size = var.loki_ingester_persistence_size
      querier_replica_count     = var.loki_querier_replica_count
      querier_persistence_size  = var.loki_querier_persistence_size
      query_frontend_replica_count = var.loki_query_frontend_replica_count
    })
  ]

  depends_on = [
    kubernetes_namespace.loki
  ]
}

// =========================
// Loki Gateway Service (data)
// =========================
data "kubernetes_service" "loki_gateway" {
  metadata {
    name      = local.loki_gateway_service_name
    namespace = kubernetes_namespace.loki.metadata[0].name
  }

  depends_on = [helm_release.loki]
}

// =========================
// Loki gateway host/port locals
// =========================
locals {
  loki_gateway_port = try(
    one([
      for p in data.kubernetes_service.loki_gateway.spec[0].port :
      p.port if p.port == 80
    ]),
    data.kubernetes_service.loki_gateway.spec[0].port[0].port
  )

  loki_service = {
    host = "${data.kubernetes_service.loki_gateway.metadata[0].name}.${kubernetes_namespace.loki.metadata[0].name}.svc.cluster.local"
    port = local.loki_gateway_port
  }
}
