# // =========================
# // Namespace for Portainer
# // =========================
# // Creates a dedicated namespace to isolate Portainer
# // and its related resources from application workloads.
# resource "kubernetes_namespace" "portainer" {
#   metadata {
#     name = "portainer"
#   }

#   // Ensure the Kubernetes cluster exists before creating the namespace
#   depends_on = [digitalocean_kubernetes_cluster.kubernetes]
# }

