resource "digitalocean_kubernetes_cluster" "kubernetes" {
  name = var.kubernetes_name
  region = var.kubernetes_region
  version = var.kubernetes_version
  node_pool {
    name = var.kubernetes_node_pool_name
    size = var.kubernetes_node_pool_size
    node_count = var.kubernetes_node_pool_node_count
    labels = {
      "doks.digitalocean.com/node-pool" = var.workload_node_pool_label
    }
  }
}