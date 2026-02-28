// =========================
// InfluxDB Helm release
// =========================
// Deploys InfluxDB using the Bitnami Helm chart (Bitnami Legacy image).
// Configuration is provided via a templated values file (influxdb.yaml).
resource "helm_release" "influxdb" {
  name      = local.influxdb.name
  namespace = kubernetes_namespace.influxdb.metadata[0].name

  chart = "oci://registry-1.docker.io/bitnamicharts/influxdb"

  values = [
    templatefile("${path.module}/yamls/influxdb.yaml", {
      node_pool_label  = var.kubernetes_primary_node_pool_name
      replica_count    = var.influxdb_replica_count
      request_cpu      = local.influxdb.influxdb.request_cpu
      request_memory   = local.influxdb.influxdb.request_memory
      limit_cpu        = local.influxdb.influxdb.limit_cpu
      limit_memory     = local.influxdb.influxdb.limit_memory
      persistence_size = var.influxdb_persistence_size
    })
  ]

  depends_on = [
    kubernetes_namespace.influxdb
  ]
}
