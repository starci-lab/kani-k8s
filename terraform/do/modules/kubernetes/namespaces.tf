# Namespace for databases
resource "kubernetes_namespace" "databases" {
  metadata {
    name = "databases"
  }
  depends_on = [ digitalocean_kubernetes_cluster.kubernetes ]
}