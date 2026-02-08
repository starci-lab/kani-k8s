// =========================
// Consul Helm release
// =========================
// Deploys HashiCorp Consul using the Bitnami Helm chart.
resource "helm_release" "consul" {
  name      = local.consul.name
  namespace = kubernetes_namespace.consul.metadata[0].name

  chart = "oci://registry-1.docker.io/bitnamicharts/consul"

  values = [
    templatefile("${path.module}/yamls/consul.yaml", {
      // Replica count
      replica_count = var.consul_replica_count
      // Node scheduling
      node_pool_label = var.kubernetes_primary_node_pool_name
      // Consul server resources
      request_cpu    = local.consul.consul.request_cpu
      request_memory = local.consul.consul.request_memory
      limit_cpu      = local.consul.consul.limit_cpu
      limit_memory   = local.consul.consul.limit_memory
      // Persistence
      persistence_size = var.consul_persistence_size
      // Volume permissions init container resources
      volume_permissions_request_cpu    = local.consul.volume_permissions.request_cpu
      volume_permissions_request_memory = local.consul.volume_permissions.request_memory
      volume_permissions_limit_cpu      = local.consul.volume_permissions.limit_cpu
      volume_permissions_limit_memory   = local.consul.volume_permissions.limit_memory
      // Gossip key
      gossip_key = var.consul_gossip_key
    })
  ]

  depends_on = [
    kubernetes_namespace.consul
  ]
}
