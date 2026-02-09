// =========================
// Loki inputs
// =========================
// Preset mappings for Loki components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
locals {
  loki_inputs = {
    presets = {
      gateway   = "16"
      compactor = "16"
      distributor = "32"
      ingester = "32"
      querier = "32"
      query_scheduler = "16"
      query_frontend = "32"
    }
  }
}

// =========================
// Loki computed values
// =========================
// Resource requests and limits for Loki components.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions.
locals {
  loki = {
    gateway = {
      request_cpu = coalesce(
        var.loki_gateway_request_cpu,
        try(var.resources_config[local.loki_inputs.presets.gateway].requests.cpu, "50m")
      )
      request_memory = coalesce(
        var.loki_gateway_request_memory,
        try(var.resources_config[local.loki_inputs.presets.gateway].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.loki_gateway_limit_cpu,
        try(var.resources_config[local.loki_inputs.presets.gateway].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.loki_gateway_limit_memory,
        try(var.resources_config[local.loki_inputs.presets.gateway].limits.memory, "128Mi")
      )
    }
    compactor = {
      request_cpu = coalesce(
        var.loki_compactor_request_cpu,
        try(var.resources_config[local.loki_inputs.presets.compactor].requests.cpu, "50m")
      )
      request_memory = coalesce(
        var.loki_compactor_request_memory,
        try(var.resources_config[local.loki_inputs.presets.compactor].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.loki_compactor_limit_cpu,
        try(var.resources_config[local.loki_inputs.presets.compactor].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.loki_compactor_limit_memory,
        try(var.resources_config[local.loki_inputs.presets.compactor].limits.memory, "128Mi")
      )
    }
    distributor = {
      request_cpu = coalesce(
        var.loki_distributor_request_cpu,
        try(var.resources_config[local.loki_inputs.presets.distributor].requests.cpu, "50m")
      )
      request_memory = coalesce(
        var.loki_distributor_request_memory,
        try(var.resources_config[local.loki_inputs.presets.distributor].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.loki_distributor_limit_cpu,
        try(var.resources_config[local.loki_inputs.presets.distributor].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.loki_distributor_limit_memory,
        try(var.resources_config[local.loki_inputs.presets.distributor].limits.memory, "128Mi")
      )
    }
    ingester = {
      request_cpu = coalesce(
        var.loki_ingester_request_cpu,
        try(var.resources_config[local.loki_inputs.presets.ingester].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.loki_ingester_request_memory,
        try(var.resources_config[local.loki_inputs.presets.ingester].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.loki_ingester_limit_cpu,
        try(var.resources_config[local.loki_inputs.presets.ingester].limits.cpu, "500m")
      )
      limit_memory = coalesce(
        var.loki_ingester_limit_memory,
        try(var.resources_config[local.loki_inputs.presets.ingester].limits.memory, "512Mi")
      )
    }
    querier = {
      request_cpu = coalesce(
        var.loki_querier_request_cpu,
        try(var.resources_config[local.loki_inputs.presets.querier].requests.cpu, "50m")
      )
      request_memory = coalesce(
        var.loki_querier_request_memory,
        try(var.resources_config[local.loki_inputs.presets.querier].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.loki_querier_limit_cpu,
        try(var.resources_config[local.loki_inputs.presets.querier].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.loki_querier_limit_memory,
        try(var.resources_config[local.loki_inputs.presets.querier].limits.memory, "128Mi")
      )
    }
    query_scheduler = {
      request_cpu = coalesce(
        var.loki_query_scheduler_request_cpu,
        try(var.resources_config[local.loki_inputs.presets.query_scheduler].requests.cpu, "50m")
      )
      request_memory = coalesce(
        var.loki_query_scheduler_request_memory,
        try(var.resources_config[local.loki_inputs.presets.query_scheduler].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.loki_query_scheduler_limit_cpu,
        try(var.resources_config[local.loki_inputs.presets.query_scheduler].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.loki_query_scheduler_limit_memory,
        try(var.resources_config[local.loki_inputs.presets.query_scheduler].limits.memory, "128Mi")
      )
    }
    query_frontend = {
      request_cpu = coalesce(
        var.loki_query_frontend_request_cpu,
        try(var.resources_config[local.loki_inputs.presets.query_frontend].requests.cpu, "50m")
      )
      request_memory = coalesce(
        var.loki_query_frontend_request_memory,
        try(var.resources_config[local.loki_inputs.presets.query_frontend].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.loki_query_frontend_limit_cpu,
        try(var.resources_config[local.loki_inputs.presets.query_frontend].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.loki_query_frontend_limit_memory,
        try(var.resources_config[local.loki_inputs.presets.query_frontend].limits.memory, "128Mi")
      )
    }
    name = "loki"
    // Services for Loki
    services = {
      gateway_service = {
        name = "loki-grafana-loki-gateway"
        port = 80
      }
      distributor_service = {
        name = "loki-grafana-loki-distributor"
        port = 3100
      }
    }
  }
}

// =========================
// Loki outputs
// =========================
// Service port resolution and computed service information.
// These values depend on data sources and are separated to avoid dependency cycles.
locals {
  loki_outputs = {
    gateway_service = {
      host = "${data.kubernetes_service.loki_gateway.metadata[0].name}.${kubernetes_namespace.loki.metadata[0].name}.svc.cluster.local"
      port = try(
        one([
          for p in data.kubernetes_service.loki_gateway.spec[0].port :
          p.port if p.port == local.loki.services.gateway_service.port
        ]),
        data.kubernetes_service.loki_gateway.spec[0].port[0].port
      )
    }
  }
}
