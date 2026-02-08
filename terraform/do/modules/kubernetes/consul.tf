// =========================
// Namespace for Consul
// =========================
// Creates a dedicated namespace for HashiCorp Consul resources.
resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// Consul local identifiers
// =========================
locals {
  consul_name                 = "consul"
  consul_server_service_name  = "consul"
}

// =========================
// Consul Helm release
// =========================
// Deploys HashiCorp Consul using the Bitnami Helm chart.
resource "helm_release" "consul" {
  name      = local.consul_name
  namespace = kubernetes_namespace.consul.metadata[0].name

  chart = "oci://registry-1.docker.io/bitnamicharts/consul"

  values = [
    templatefile("${path.module}/yamls/consul.yaml", {
      replica_count  = var.consul_replica_count
      node_pool_label = var.kubernetes_primary_node_pool_name
      request_cpu    = local.consul.consul.request_cpu
      request_memory = local.consul.consul.request_memory
      limit_cpu      = local.consul.consul.limit_cpu
      limit_memory   = local.consul.consul.limit_memory
      persistence_size = var.consul_persistence_size
      volume_permissions_request_cpu    = local.consul.volume_permissions.request_cpu
      volume_permissions_request_memory = local.consul.volume_permissions.request_memory
      volume_permissions_limit_cpu      = local.consul.volume_permissions.limit_cpu
      volume_permissions_limit_memory   = local.consul.volume_permissions.limit_memory
      gossip_key = var.consul_gossip_key
    })
  ]

  depends_on = [
    kubernetes_namespace.consul
  ]
}

// =========================
// Consul Service (data)
// =========================
data "kubernetes_service" "consul" {
  metadata {
    name      = local.consul_server_service_name
    namespace = kubernetes_namespace.consul.metadata[0].name
  }

  depends_on = [helm_release.consul]
}

// =========================
// Consul host/port locals
// =========================
locals {
  consul_service = {
    host = "${data.kubernetes_service.consul.metadata[0].name}.${kubernetes_namespace.consul.metadata[0].name}.svc.cluster.local"
    port = 80
  }
}
