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
  pod_templates = {
    deployment-rollout-jenkins-agent = {
      name = "deployment-rollout-jenkins-agent"
      yaml = data.template_file.jenkins_deployment_rollout_agent.rendered
    }
  }
  containers = {
    kani_interface = {
      file        = "kani-interface-deployment-rollout-pipeline"
      name        = "kani-interface-deployment-rollout-pipeline"                                          # Name of the Jenkins pipeline job
      description = "Rollout the kani interface deployment using Kubernetes" # Job description
      pipeline_script = templatefile("${path.module}/scripts/jenkins/jenkinsfiles/deployment-rollout.jenkinsfile", {
        deployment_name = "kani-interface-service"
        namespace = "kani"
        inherit_from = local.pod_templates["deployment-rollout-jenkins-agent"].name
      })
      webhook_token = var.kani_interface_deployment_rollout_webhook_token
    }
    kani_coordinator = {
      file        = "kani-coordinator-deployment-rollout-pipeline"
      name        = "kani-coordinator-deployment-rollout-pipeline"                                          # Name of the Jenkins pipeline job
      description = "Rollout the kani coordinator deployment using Kubernetes" # Job description
      pipeline_script = templatefile("${path.module}/scripts/jenkins/jenkinsfiles/deployment-rollout.jenkinsfile", {
        deployment_name = "kani-coordinator-service"
        namespace = "kani"
        inherit_from = local.pod_templates["deployment-rollout-jenkins-agent"].name
      })
      webhook_token = var.kani_coordinator_deployment_rollout_webhook_token
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
      deployment_rollout_agent_yaml = local.pod_templates["deployment-rollout-jenkins-agent"].yaml,
      container_cap    = var.jenkins_agent_container_cap,
      service_account  = kubernetes_service_account.jenkins_agent.metadata[0].name,
      pod_template_name = local.pod_templates["deployment-rollout-jenkins-agent"].name
    })
  }
  jenkins_init_groovy_cm_2 = {
    for job in local.containers :
    "${job.file}.groovy" => templatefile("${path.module}/scripts/jenkins/groovy/generic-webhook-trigger-pipeline.groovy", {
      job_name = job.name
      job_description = "${job.description}"
      pipeline_script = job.pipeline_script
      webhook_token = job.webhook_token
    })
  }
  jenkins_init_groovy_cm = merge(local.jenkins_init_groovy_cm_1, local.jenkins_init_groovy_cm_2)
}

resource "kubernetes_config_map" "jenkins_init_groovy_cm" {
  metadata {
    name      = local.jenkins_init_groovy_name
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }
  data = local.jenkins_init_groovy_cm

  depends_on = [
    kubernetes_service_account.jenkins_agent
  ]
}