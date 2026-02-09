// =========================
// Loki Monolithic inputs
// =========================
// Preset mappings for Loki monolithic (SingleBinary).
// Maps component to resource size key for preset lookup.
locals {
  loki_monolithic_inputs = {
    presets = {
      single_binary = "32"
    }
  }
}

// =========================
// Loki Monolithic computed values
// =========================
// Resource requests and limits for Loki monolithic single-binary.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming and services configuration.
locals {
  loki_monolithic = {
    single_binary = {
      request_cpu = coalesce(
        var.loki_monolithic_request_cpu,
        try(var.resources_config[local.loki_monolithic_inputs.presets.single_binary].requests.cpu, "200m")
      )
      request_memory = coalesce(
        var.loki_monolithic_request_memory,
        try(var.resources_config[local.loki_monolithic_inputs.presets.single_binary].requests.memory, "256Mi")
      )
      limit_cpu = coalesce(
        var.loki_monolithic_limit_cpu,
        try(var.resources_config[local.loki_monolithic_inputs.presets.single_binary].limits.cpu, "500m")
      )
      limit_memory = coalesce(
        var.loki_monolithic_limit_memory,
        try(var.resources_config[local.loki_monolithic_inputs.presets.single_binary].limits.memory, "512Mi")
      )
    }
    name = "loki-monolithic"
    // Services for Loki Monolithic (Grafana chart single-binary creates this service)
    services = {
      single_binary_service = {
        name = "loki-monolithic-loki"
        port = 3100
      }
    }
  }
}

// =========================
// Loki Monolithic outputs
// =========================
// Service host and port for Loki monolithic single-binary.
// Depends on data source from loki_monolithic_resources_networking.tf.
locals {
  loki_monolithic_outputs = {
    single_binary_service = {
      host = "${data.kubernetes_service.loki_monolithic.metadata[0].name}.${kubernetes_namespace.loki.metadata[0].name}.svc.cluster.local"
      port = try(
        one([
          for p in data.kubernetes_service.loki_monolithic.spec[0].port :
          p.port if p.port == local.loki_monolithic.services.single_binary_service.port
        ]),
        data.kubernetes_service.loki_monolithic.spec[0].port[0].port
      )
    }
  }
}
