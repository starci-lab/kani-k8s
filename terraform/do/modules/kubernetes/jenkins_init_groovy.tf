// =========================
// Jenkins deployment rollout agent template
// =========================
// Template file for the Kubernetes Pod spec used by Jenkins agents
// for deployment rollout operations.
data "template_file" "jenkins_deployment_rollout_agent" {
  template = file("${path.module}/yamls/deployment-rollout-template.yaml")
  vars = {
    node_pool_label = var.kubernetes_primary_node_pool_name
    request_cpu     = local.jenkins.agent.request_cpu
    request_memory  = local.jenkins.agent.request_memory
    limit_cpu       = local.jenkins.agent.limit_cpu
    limit_memory    = local.jenkins.agent.limit_memory
  }
}

locals {
  containers = {
    kani_interface = {
      file        = "kani-interface-deployment-rollout-pipeline"
      name        = "Kani Interface Deployment Rollout Pipeline"                                          # Name of the Jenkins pipeline job
      description = "Rollout the kani interface deployment using Kubernetes" # Job description
    }

  }
}

locals {
  jenkins_init_groovy_name = "jenkins-init-groovy"
  // Create ConfigMap for Jenkins init groovy scripts
  jenkins_init_groovy_cm_1 = {
    "kubernetes-cloud.groovy" = templatefile("${path.module}/scripts/jenkins/groovy/kubernetes-cloud.groovy", {
      node_selector    = "doks.digitalocean.com/node-pool=${var.kubernetes_primary_node_pool_name}"
      namespace        = kubernetes_namespace.jenkins.metadata[0].name,
      deployment_rollout_agent_yaml = data.template_file.jenkins_deployment_rollout_agent.rendered,
      container_cap    = var.jenkins_agent_container_cap,
    })
  }

  jenkins_init_groovy_cm = merge(local.jenkins_init_groovy_cm_1)
}

resource "kubernetes_config_map" "jenkins_init_groovy_cm" {
  metadata {
    name = local.jenkins_init_groovy_name
  }
  data = local.jenkins_init_groovy_cm
}