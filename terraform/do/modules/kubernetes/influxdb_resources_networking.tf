// =========================
// InfluxDB Service (data)
// =========================
// Used to build the InfluxDB service address for clients.
data "kubernetes_service" "influxdb" {
  metadata {
    name      = local.influxdb.services.server_service.name
    namespace = kubernetes_namespace.influxdb.metadata[0].name
  }
  depends_on = [helm_release.influxdb]
}
