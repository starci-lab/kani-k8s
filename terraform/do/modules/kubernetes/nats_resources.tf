// =========================
// Namespace for NATS
// =========================
resource "kubernetes_namespace" "nats" {
  metadata {
    name = "nats"
  }
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// NATS Service (data)
// =========================
data "kubernetes_service" "nats" {
  metadata {
    name      = local.nats.services.service.name
    namespace = kubernetes_namespace.nats.metadata[0].name
  }
  depends_on = [helm_release.nats]
}

// =========================
// NATS Headless Service (data)
// =========================
data "kubernetes_service" "nats_headless" {
  metadata {
    name      = local.nats.services.headless_service.name
    namespace = kubernetes_namespace.nats.metadata[0].name
  }
  depends_on = [helm_release.nats]
}
