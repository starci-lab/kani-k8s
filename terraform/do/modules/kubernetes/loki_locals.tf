// =========================
// Loki computed values
// =========================
// Resource requests and limits for Loki components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions and service configuration.

locals {
  loki = {
    presets = {
      gateway   = "16"
      compactor = "16"
    }
    gateway = {
      request_cpu = coalesce(
        var.loki_gateway_request_cpu,
        try(var.resources_config[local.loki.presets.gateway].requests.cpu, "50m")
      )
      request_memory = coalesce(
        var.loki_gateway_request_memory,
        try(var.resources_config[local.loki.presets.gateway].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.loki_gateway_limit_cpu,
        try(var.resources_config[local.loki.presets.gateway].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.loki_gateway_limit_memory,
        try(var.resources_config[local.loki.presets.gateway].limits.memory, "128Mi")
      )
    }
    compactor = {
      request_cpu = coalesce(
        var.loki_compactor_request_cpu,
        try(var.resources_config[local.loki.presets.compactor].requests.cpu, "50m")
      )
      request_memory = coalesce(
        var.loki_compactor_request_memory,
        try(var.resources_config[local.loki.presets.compactor].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.loki_compactor_limit_cpu,
        try(var.resources_config[local.loki.presets.compactor].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.loki_compactor_limit_memory,
        try(var.resources_config[local.loki.presets.compactor].limits.memory, "128Mi")
      )
    }
    name = "loki"
    gateway_service_name = "loki-gateway"
    gateway_port = try(
      one([
        for p in data.kubernetes_service.loki_gateway.spec[0].port :
        p.port if p.port == 80
      ]),
      data.kubernetes_service.loki_gateway.spec[0].port[0].port
    )
    service = {
      host = "${data.kubernetes_service.loki_gateway.metadata[0].name}.${kubernetes_namespace.loki.metadata[0].name}.svc.cluster.local"
      port = local.loki.gateway_port
    }
  }
}
