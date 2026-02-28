// =========================
// Namespace for InfluxDB
// =========================
// Creates a dedicated namespace for InfluxDB resources.
resource "kubernetes_namespace" "influxdb" {
  metadata {
    name = "influxdb"
  }

  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// InfluxDB Service (data)
// =========================
// Fetches the Service created by the InfluxDB Helm chart.
data "kubernetes_service" "influxdb" {
  metadata {
    name      = local.influxdb.services.server_service.name
    namespace = kubernetes_namespace.influxdb.metadata[0].name
  }
  depends_on = [helm_release.influxdb]
}

// =========================
// InfluxDB Service (data)
// =========================
// Fetches the Service created by the InfluxDB Helm chart.
data "kubernetes_secret" "influxdb" {
  metadata {
    name      = "influxdb"
    namespace = kubernetes_namespace.influxdb.metadata[0].name
  }
  depends_on = [helm_release.influxdb]
}