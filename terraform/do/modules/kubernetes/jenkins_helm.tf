// =========================
// Jenkins Helm release
// =========================
// Deploys Jenkins using the Bitnami OCI Helm chart.
// All configuration is injected via a Terraform-rendered values file.
# resource "helm_release" "jenkins" {
#   name      = local.jenkins.name
#   namespace = kubernetes_namespace.jenkins.metadata[0].name
#
#   // Bitnami Jenkins chart from Docker Hub OCI registry
#   chart = "oci://registry-1.docker.io/bitnamicharts/jenkins"
#
#   // Render Helm values from template and inject Terraform variables
#   values = [
#     templatefile("${path.module}/yamls/jenkins.yaml", {
#       // Jenkins authentication
#       jenkins_user     = var.jenkins_user
#       jenkins_password = var.jenkins_password
#       // Replica count
#       replica_count = var.jenkins_replica_count
#       // Jenkins resources
#       request_cpu    = local.jenkins.jenkins.request_cpu
#       request_memory = local.jenkins.jenkins.request_memory
#       limit_cpu      = local.jenkins.jenkins.limit_cpu
#       limit_memory   = local.jenkins.jenkins.limit_memory
#       // Volume permissions init container resources
#       volume_permissions_request_cpu    = local.jenkins.volume_permissions.request_cpu
#       volume_permissions_request_memory = local.jenkins.volume_permissions.request_memory
#       volume_permissions_limit_cpu      = local.jenkins.volume_permissions.limit_cpu
#       volume_permissions_limit_memory   = local.jenkins.volume_permissions.limit_memory
#       // Persistence
#       persistence_size = var.jenkins_persistence_size
#       // Jenkins init groovy scripts
#       init_hook_scripts_cm = kubernetes_config_map.jenkins_init_groovy_cm.metadata[0].name
#       init_hook_scripts_secret = ""
#     })
#   ]
#
#   // Ensure the Jenkins namespace exists before installing the chart
#   depends_on = [
#     kubernetes_namespace.jenkins
#   ]
# }
