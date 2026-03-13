// =========================
// NATS Helm release (Bitnami)
// =========================
resource "helm_release" "nats" {
  name      = local.nats.name
  namespace = kubernetes_namespace.nats.metadata[0].name
  chart     = "oci://registry-1.docker.io/bitnamicharts/nats"

  values = [
    templatefile("${path.module}/yamls/nats.yaml", {
      replica_count   = var.nats_replica_count
      request_cpu     = local.nats.nats.request_cpu
      request_memory  = local.nats.nats.request_memory
      limit_cpu       = local.nats.nats.limit_cpu
      limit_memory    = local.nats.nats.limit_memory
      node_pool_label = var.kubernetes_primary_node_pool_name
      auth_enabled    = tostring(var.nats_auth_enabled)
      auth_token      = var.nats_auth_token
    })
  ]

  depends_on = [
    kubernetes_namespace.nats
  ]
}
