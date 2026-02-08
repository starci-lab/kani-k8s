// =========================
// Namespace for Jenkins
// =========================
// Creates a dedicated namespace to isolate Jenkins
// and its related resources from application workloads.
# resource "kubernetes_namespace" "jenkins" {
#   metadata {
#     name = "jenkins"
#   }
#
#   // Ensure the Kubernetes cluster exists before creating the namespace
#   depends_on = [digitalocean_kubernetes_cluster.kubernetes]
# }
