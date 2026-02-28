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
