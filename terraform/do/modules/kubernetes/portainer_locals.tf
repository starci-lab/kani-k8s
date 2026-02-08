// =========================
// Portainer computed values
// =========================
// Resource requests and limits for Portainer components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions and service port resolution.

locals {
  portainer = {
    presets = {
      portainer = "16"
    }
    portainer = {
      request_cpu = coalesce(
        var.portainer_request_cpu,
        try(var.resources_config[local.portainer.presets.portainer].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.portainer_request_memory,
        try(var.resources_config[local.portainer.presets.portainer].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.portainer_limit_cpu,
        try(var.resources_config[local.portainer.presets.portainer].limits.cpu, "64m")
      )
      limit_memory = coalesce(
        var.portainer_limit_memory,
        try(var.resources_config[local.portainer.presets.portainer].limits.memory, "128Mi")
      )
    }
    name = "portainer"
    server_service_name = "portainer"
    server_port = try(
      one([
        for p in data.kubernetes_service.portainer_server.spec[0].port :
        p.port if p.port == 9000
      ]),
      data.kubernetes_service.portainer_server.spec[0].port[0].port
    )
  }
}
