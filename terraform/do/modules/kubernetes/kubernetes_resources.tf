// =========================
// DigitalOcean Kubernetes cluster (DOKS)
// =========================
// Provisions a managed Kubernetes cluster on DigitalOcean
// with a primary node pool used for general workloads.
resource "digitalocean_kubernetes_cluster" "kubernetes" {
  // Name of the Kubernetes cluster
  name    = var.kubernetes_name

  // DigitalOcean region where the cluster will be created
  region = var.kubernetes_region

  // Kubernetes version for the cluster
  version = var.kubernetes_version

  // =========================
  // Primary node pool
  // =========================
  // Defines the main worker node pool for the cluster.
  node_pool {
    // Name of the primary node pool
    name = var.kubernetes_primary_node_pool_name

    // Droplet size (instance type) for nodes in this pool
    size = var.kubernetes_primary_node_pool_size

    // Number of worker nodes in the primary node pool
    node_count = var.kubernetes_primary_node_pool_node_count

    // Node labels applied to all nodes in this pool
    // Used for scheduling, affinity rules, and workload targeting.
    labels = {
      "doks.digitalocean.com/node-pool" = var.kubernetes_primary_node_pool_name
    }
  }
}
