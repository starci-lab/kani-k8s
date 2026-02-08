// =========================
// Jenkins deployment rollout agent template
// =========================
// Template file for the Kubernetes Pod spec used by Jenkins agents
// for deployment rollout operations.
# data "template_file" "jenkins_deployment_rollout_agent" {
#   template = file("${path.module}/yamls/deployment-rollout-template.yaml")
#   vars = {
#     node_pool_label = var.kubernetes_primary_node_pool_name
#     request_cpu     = local.jenkins.agent.request_cpu
#     request_memory  = local.jenkins.agent.request_memory
#     limit_cpu       = local.jenkins.agent.limit_cpu
#     limit_memory    = local.jenkins.agent.limit_memory
#   }
# }

// =========================
// Jenkins init Groovy ConfigMap resource
// =========================
// Creates a ConfigMap containing Groovy scripts for Jenkins initialization.
# resource "kubernetes_config_map" "jenkins_init_groovy_cm" {
#   metadata {
#     name      = local.jenkins.init_groovy_name
#     namespace = kubernetes_namespace.jenkins.metadata[0].name
#   }
#   data = local.jenkins.init_groovy_cm
#
#   depends_on = [
#     kubernetes_service_account.jenkins_agent
#   ]
# }
