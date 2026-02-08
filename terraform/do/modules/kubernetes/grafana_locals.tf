// =========================
// Grafana inputs
// =========================
// Preset mappings for Grafana components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
locals {
  grafana_inputs = {
    presets = {
      grafana = "16"
    }
  }
}

// =========================
// Grafana computed values
// =========================
// Resource requests and limits for Grafana components.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions.
locals {
  grafana = {
    grafana = {
      request_cpu = coalesce(
        var.grafana_request_cpu,
        try(var.resources_config[local.grafana_inputs.presets.grafana].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.grafana_request_memory,
        try(var.resources_config[local.grafana_inputs.presets.grafana].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.grafana_limit_cpu,
        try(var.resources_config[local.grafana_inputs.presets.grafana].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.grafana_limit_memory,
        try(var.resources_config[local.grafana_inputs.presets.grafana].limits.memory, "256Mi")
      )
    }
    name = "grafana"
    server_service_name = "grafana"
  }
}

// =========================
// Grafana outputs
// =========================
// Service port resolution and computed service information.
// These values depend on data sources and are separated to avoid dependency cycles.
locals {
  grafana_outputs = {
    server_port = try(
      one([
        for p in data.kubernetes_service.grafana_server.spec[0].port :
        p.port if p.port == 3000
      ]),
      data.kubernetes_service.grafana_server.spec[0].port[0].port
    )
  }
}
