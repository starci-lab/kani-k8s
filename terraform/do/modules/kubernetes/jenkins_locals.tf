// =========================
// Jenkins inputs
// =========================
// Preset mappings for Jenkins components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
locals {
  jenkins_inputs = {
    presets = {
      jenkins            = "96"
      volume_permissions = "16"
      agent              = "32"
    }
  }
}

// =========================
// Jenkins base computed values
// =========================
// Resource requests and limits for Jenkins components.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions and pod templates.
locals {
  jenkins_base = {
    jenkins = {
      request_cpu = coalesce(
        var.jenkins_request_cpu,
        try(var.resources_config[local.jenkins_inputs.presets.jenkins].requests.cpu, "500m")
      )
      request_memory = coalesce(
        var.jenkins_request_memory,
        try(var.resources_config[local.jenkins_inputs.presets.jenkins].requests.memory, "512Mi")
      )
      limit_cpu = coalesce(
        var.jenkins_limit_cpu,
        try(var.resources_config[local.jenkins_inputs.presets.jenkins].limits.cpu, "2000m")
      )
      limit_memory = coalesce(
        var.jenkins_limit_memory,
        try(var.resources_config[local.jenkins_inputs.presets.jenkins].limits.memory, "2048Mi")
      )
    }
    volume_permissions = {
      request_cpu = coalesce(
        var.jenkins_volume_permissions_request_cpu,
        try(var.resources_config[local.jenkins_inputs.presets.volume_permissions].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.jenkins_volume_permissions_request_memory,
        try(var.resources_config[local.jenkins_inputs.presets.volume_permissions].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.jenkins_volume_permissions_limit_cpu,
        try(var.resources_config[local.jenkins_inputs.presets.volume_permissions].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.jenkins_volume_permissions_limit_memory,
        try(var.resources_config[local.jenkins_inputs.presets.volume_permissions].limits.memory, "256Mi")
      )
    }
    agent = {
      request_cpu = coalesce(
        var.jenkins_agent_request_cpu,
        try(var.resources_config[local.jenkins_inputs.presets.agent].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.jenkins_agent_request_memory,
        try(var.resources_config[local.jenkins_inputs.presets.agent].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.jenkins_agent_limit_cpu,
        try(var.resources_config[local.jenkins_inputs.presets.agent].limits.cpu, "500m")
      )
      limit_memory = coalesce(
        var.jenkins_agent_limit_memory,
        try(var.resources_config[local.jenkins_inputs.presets.agent].limits.memory, "512Mi")
      )
    }
    name = "jenkins"
    // Services for Jenkins
    services = {
      server_service = {
        name = "jenkins"
        port = 80
      }
    }
  }
}

// =========================
// Jenkins outputs
// =========================
// Service port resolution, pod templates, and computed service information.
// These values depend on data sources and are separated to avoid dependency cycles.
// Commented out because the data sources are commented out.
# locals {
#   jenkins_outputs = {
#     server_port = try(
#       one([
#         for p in data.kubernetes_service.jenkins_server.spec[0].port :
#         p.port if p.port == 80
#       ]),
#       data.kubernetes_service.jenkins_server.spec[0].port[0].port
#     )
#     pod_templates = {
#       deployment-rollout-jenkins-agent = {
#         name = "deployment-rollout-jenkins-agent"
#         yaml = data.template_file.jenkins_deployment_rollout_agent.rendered
#       }
#     }
#   }
# }

// Placeholder outputs when data sources are commented out
locals {
  jenkins_outputs = {
    server_port = local.jenkins_base.services.server_service.port
    pod_templates = {
      deployment-rollout-jenkins-agent = {
        name = "deployment-rollout-jenkins-agent"
        yaml = ""
      }
    }
  }
}

// =========================
// Jenkins containers
// =========================
// Container definitions that depend on pod_templates.
locals {
  jenkins_containers = {
    kani_interface = {
      file        = "kani-interface-deployment-rollout-pipeline"
      name        = "kani-interface-deployment-rollout-pipeline"
      description = "Rollout the kani interface deployment using Kubernetes"
      pipeline_script = templatefile("${path.module}/scripts/jenkins/jenkinsfiles/deployment-rollout.jenkinsfile", {
        deployment_name = "kani-interface-service"
        namespace = "kani"
        inherit_from = local.jenkins_outputs.pod_templates["deployment-rollout-jenkins-agent"].name
      })
      webhook_token = var.kani_interface_deployment_rollout_webhook_token
    }
    kani_coordinator = {
      file        = "kani-coordinator-deployment-rollout-pipeline"
      name        = "kani-coordinator-deployment-rollout-pipeline"
      description = "Rollout the kani coordinator deployment using Kubernetes"
      pipeline_script = templatefile("${path.module}/scripts/jenkins/jenkinsfiles/deployment-rollout.jenkinsfile", {
        deployment_name = "kani-coordinator-service"
        namespace = "kani"
        inherit_from = local.jenkins_outputs.pod_templates["deployment-rollout-jenkins-agent"].name
      })
      webhook_token = var.kani_coordinator_deployment_rollout_webhook_token
    }
    kani_observer = {
      file        = "kani-observer-deployment-rollout-pipeline"
      name        = "kani-observer-deployment-rollout-pipeline"
      description = "Rollout the kani observer deployment using Kubernetes"
      pipeline_script = templatefile("${path.module}/scripts/jenkins/jenkinsfiles/deployment-rollout.jenkinsfile", {
        deployment_name = "kani-observer-service"
        namespace = "kani"
        inherit_from = local.jenkins_outputs.pod_templates["deployment-rollout-jenkins-agent"].name
      })
      webhook_token = var.kani_observer_deployment_rollout_webhook_token
    }
  }
}

// =========================
// Jenkins init groovy
// =========================
// Init groovy scripts that depend on pod_templates and containers.
locals {
  jenkins_init_groovy_base = {
    init_groovy_name = "jenkins-init-groovy"
    // Placeholder values for namespace and service_account when resources are commented out
    // Uncomment the resource references below when kubernetes_namespace.jenkins and kubernetes_service_account.jenkins_agent are active
    // Replace "jenkins" with kubernetes_namespace.jenkins.metadata[0].name when active
    // Replace "jenkins-agent" with kubernetes_service_account.jenkins_agent.metadata[0].name when active
    init_groovy_cm_1 = {
      "kubernetes-cloud.groovy" = templatefile("${path.module}/scripts/jenkins/groovy/kubernetes-cloud.groovy", {
        node_selector    = "doks.digitalocean.com/node-pool=${var.kubernetes_primary_node_pool_name}"
        namespace        = "jenkins"
        deployment_rollout_agent_yaml = local.jenkins_outputs.pod_templates["deployment-rollout-jenkins-agent"].yaml,
        container_cap    = var.jenkins_agent_container_cap,
        service_account  = "jenkins-agent"
        pod_template_name = local.jenkins_outputs.pod_templates["deployment-rollout-jenkins-agent"].name
      })
    }
    init_groovy_cm_2 = {
      for job in local.jenkins_containers :
      "${job.file}.groovy" => templatefile("${path.module}/scripts/jenkins/groovy/generic-webhook-trigger-pipeline.groovy", {
        job_name = job.name
        job_description = "${job.description}"
        pipeline_script = job.pipeline_script
        webhook_token = job.webhook_token
      })
    }
  }
  jenkins_init_groovy = merge(
    local.jenkins_init_groovy_base,
    {
      init_groovy_cm = merge(local.jenkins_init_groovy_base.init_groovy_cm_1, local.jenkins_init_groovy_base.init_groovy_cm_2)
    }
  )
}

// =========================
// Jenkins merged output
// =========================
// Merge all jenkins locals into a single output for convenience.
locals {
  jenkins = merge(
    local.jenkins_base,
    local.jenkins_outputs,
    {
      containers = local.jenkins_containers
    },
    local.jenkins_init_groovy
  )
}
