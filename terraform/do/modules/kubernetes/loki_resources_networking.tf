// =========================
// Loki Gateway Service (data)
// =========================
// Used to build the Loki service address for clients.
data "kubernetes_service" "loki_gateway" {
  metadata {
    name      = local.loki.services.gateway_service.name
    namespace = kubernetes_namespace.loki.metadata[0].name
  }

  depends_on = [helm_release.loki]
}
