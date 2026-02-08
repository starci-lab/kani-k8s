// =========================
// External Secrets inputs
// =========================
// Preset mappings for External Secrets components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
locals {
  external_secrets_inputs = {
    presets = {
      external_secrets  = "16"
      webhook           = "16"
      cert_controller   = "16"
    }
  }
}

// =========================
// External Secrets computed values
// =========================
// Resource requests and limits for External Secrets components.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes ExternalSecret instances configuration and GCP ClusterSecretStore configuration.
locals {
  external_secrets = {
    external_secrets = {
      request_cpu = coalesce(
        var.external_secrets_request_cpu,
        try(var.resources_config[local.external_secrets_inputs.presets.external_secrets].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.external_secrets_request_memory,
        try(var.resources_config[local.external_secrets_inputs.presets.external_secrets].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.external_secrets_limit_cpu,
        try(var.resources_config[local.external_secrets_inputs.presets.external_secrets].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.external_secrets_limit_memory,
        try(var.resources_config[local.external_secrets_inputs.presets.external_secrets].limits.memory, "256Mi")
      )
    }
    webhook = {
      request_cpu = coalesce(
        var.webhook_request_cpu,
        try(var.resources_config[local.external_secrets_inputs.presets.webhook].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.webhook_request_memory,
        try(var.resources_config[local.external_secrets_inputs.presets.webhook].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.webhook_limit_cpu,
        try(var.resources_config[local.external_secrets_inputs.presets.webhook].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.webhook_limit_memory,
        try(var.resources_config[local.external_secrets_inputs.presets.webhook].limits.memory, "256Mi")
      )
    }
    cert_controller = {
      request_cpu = coalesce(
        var.cert_controller_request_cpu,
        try(var.resources_config[local.external_secrets_inputs.presets.cert_controller].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.cert_controller_request_memory,
        try(var.resources_config[local.external_secrets_inputs.presets.cert_controller].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.cert_controller_limit_cpu,
        try(var.resources_config[local.external_secrets_inputs.presets.cert_controller].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.cert_controller_limit_memory,
        try(var.resources_config[local.external_secrets_inputs.presets.cert_controller].limits.memory, "256Mi")
      )
    }
    instances = {
      app = {
        name               = "app"
        target_secret_name = "app"
        target_secret_key  = "data"
        gcp_secret_name    = "app"
        version            = var.app_secret_version
      }
      rpcs = {
        name               = "rpcs"
        target_secret_name = "rpcs"
        target_secret_key  = "data"
        gcp_secret_name    = "rpcs"
        version            = var.rpcs_secret_version
      }
    }
    gcp_cluster_secret_store = {
      name = "gcp-secret-store"
    }
  }
}
