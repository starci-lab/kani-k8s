// =========================
// Namespace for MongoDB Sharded
// =========================
// Creates a dedicated namespace to isolate all MongoDB sharded
// cluster components (Config Server, Shard Servers, Mongos routers).
resource "kubernetes_namespace" "mongodb_sharded" {
  metadata {
    name = "mongodb-sharded"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// MongoDB Sharded Service (data)
// =========================
// Used to build the MongoDB Sharded service address for clients.
data "kubernetes_service" "mongodb_sharded" {
  metadata {
    name      = "mongodb-sharded"
    namespace = kubernetes_namespace.mongodb_sharded.metadata[0].name
  }
}
