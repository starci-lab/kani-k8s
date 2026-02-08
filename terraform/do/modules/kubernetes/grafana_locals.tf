// =========================
// Grafana computed values
// =========================
// Resource requests and limits for Grafana components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions and service port resolution.
// Service port selects the HTTP port (3000) if available, otherwise falls back to the first declared port.
locals {
  grafana = {
    presets = {
      grafana = "16"
    }
    grafana = {
      request_cpu = coalesce(
        var.grafana_request_cpu,
        try(var.resources_config[local.grafana.presets.grafana].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.grafana_request_memory,
        try(var.resources_config[local.grafana.presets.grafana].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.grafana_limit_cpu,
        try(var.resources_config[local.grafana.presets.grafana].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.grafana_limit_memory,
        try(var.resources_config[local.grafana.presets.grafana].limits.memory, "256Mi")
      )
    }
    name = "grafana"
    server_service_name = "grafana"
    server_port = try(
      one([
        for p in data.kubernetes_service.grafana_server.spec[0].port :
        p.port if p.port == 3000
      ]),
      data.kubernetes_service.grafana_server.spec[0].port[0].port
    )
  }
}
