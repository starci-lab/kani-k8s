// =========================
// Portainer inputs
// =========================
// Preset mappings for Portainer components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
locals {
  portainer_inputs = {
    presets = {
      portainer = "16"
    }
  }
}

// =========================
// Portainer computed values
// =========================
// Resource requests and limits for Portainer components.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions.
locals {
  portainer = {
    portainer = {
      request_cpu = coalesce(
        var.portainer_request_cpu,
        try(var.resources_config[local.portainer_inputs.presets.portainer].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.portainer_request_memory,
        try(var.resources_config[local.portainer_inputs.presets.portainer].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.portainer_limit_cpu,
        try(var.resources_config[local.portainer_inputs.presets.portainer].limits.cpu, "64m")
      )
      limit_memory = coalesce(
        var.portainer_limit_memory,
        try(var.resources_config[local.portainer_inputs.presets.portainer].limits.memory, "128Mi")
      )
    }
    name = "portainer"
    // Services for Portainer
    services = {
      server_service = {
        name = "portainer"
        port = 9000
      }
    }
  }
}

// =========================
// Portainer outputs
// =========================
// Service port resolution and computed service information.
// These values depend on data sources and are separated to avoid dependency cycles.
locals {
  portainer_outputs = {
    server_port = try(
        one([
          for p in data.kubernetes_service.portainer_server.spec[0].port :
          p.port if p.port == local.portainer.services.server_service.port
        ]),
        data.kubernetes_service.portainer_server.spec[0].port[0].port
      )
  }
}
