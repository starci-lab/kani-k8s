// =========================
// Computed resource values
// =========================
// Resource requests and limits for cert-manager components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
locals {
  cert_manager = {
    presets = {
      cert_manager = "16"
      webhook      = "16"
      cainjector   = "16"
      controller   = "16"
    }
    cert_manager = {
      request_cpu = coalesce(
        var.cert_manager_cert_manager_request_cpu,
        try(var.resources_config[local.cert_manager.presets.cert_manager].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.cert_manager_cert_manager_request_memory,
        try(var.resources_config[local.cert_manager.presets.cert_manager].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.cert_manager_cert_manager_limit_cpu,
        try(var.resources_config[local.cert_manager.presets.cert_manager].limits.cpu, "256m")
      )
      limit_memory = coalesce(
        var.cert_manager_cert_manager_limit_memory,
        try(var.resources_config[local.cert_manager.presets.cert_manager].limits.memory, "512Mi")
      )
    }

    webhook = {
      request_cpu = coalesce(
        var.cert_manager_webhook_request_cpu,
        try(var.resources_config[local.cert_manager.presets.webhook].requests.cpu, "64m")
      )
      request_memory = coalesce(
        var.cert_manager_webhook_request_memory,
        try(var.resources_config[local.cert_manager.presets.webhook].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.cert_manager_webhook_limit_cpu,
        try(var.resources_config[local.cert_manager.presets.webhook].limits.cpu, "256m")
      )
      limit_memory = coalesce(
        var.cert_manager_webhook_limit_memory,
        try(var.resources_config[local.cert_manager.presets.webhook].limits.memory, "512Mi")
      )
    }

    cainjector = {
      request_cpu = coalesce(
        var.cert_manager_cainjector_request_cpu,
        try(var.resources_config[local.cert_manager.presets.cainjector].requests.cpu, "64m")
      )
      request_memory = coalesce(
        var.cert_manager_cainjector_request_memory,
        try(var.resources_config[local.cert_manager.presets.cainjector].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.cert_manager_cainjector_limit_cpu,
        try(var.resources_config[local.cert_manager.presets.cainjector].limits.cpu, "256m")
      )
      limit_memory = coalesce(
        var.cert_manager_cainjector_limit_memory,
        try(var.resources_config[local.cert_manager.presets.cainjector].limits.memory, "512Mi")
      )
    }

    controller = {
      request_cpu = coalesce(
        var.cert_manager_controller_request_cpu,
        try(var.resources_config[local.cert_manager.presets.controller].requests.cpu, "64m")
      )
      request_memory = coalesce(
        var.cert_manager_controller_request_memory,
        try(var.resources_config[local.cert_manager.presets.controller].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.cert_manager_controller_limit_cpu,
        try(var.resources_config[local.cert_manager.presets.controller].limits.cpu, "256m")
      )
      limit_memory = coalesce(
        var.cert_manager_controller_limit_memory,
        try(var.resources_config[local.cert_manager.presets.controller].limits.memory, "512Mi")
      )
    }
  }
}
