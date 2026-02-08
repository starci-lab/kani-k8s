// =========================
// Consul inputs
// =========================
// Preset mappings for Consul components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
locals {
  consul_inputs = {
    presets = {
      consul             = "32"
      volume_permissions = "16"
      exporter           = "16"
    }
  }
}

// =========================
// Consul computed values
// =========================
// Resource requests and limits for Consul components.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions.
locals {
  consul = {
    consul = {
      request_cpu = coalesce(
        var.consul_request_cpu,
        try(var.resources_config[local.consul_inputs.presets.consul].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.consul_request_memory,
        try(var.resources_config[local.consul_inputs.presets.consul].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.consul_limit_cpu,
        try(var.resources_config[local.consul_inputs.presets.consul].limits.cpu, "256m")
      )
      limit_memory = coalesce(
        var.consul_limit_memory,
        try(var.resources_config[local.consul_inputs.presets.consul].limits.memory, "256Mi")
      )
    }
    volume_permissions = {
      request_cpu = coalesce(
        var.consul_volume_permissions_request_cpu,
        try(var.resources_config[local.consul_inputs.presets.volume_permissions].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.consul_volume_permissions_request_memory,
        try(var.resources_config[local.consul_inputs.presets.volume_permissions].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.consul_volume_permissions_limit_cpu,
        try(var.resources_config[local.consul_inputs.presets.volume_permissions].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.consul_volume_permissions_limit_memory,
        try(var.resources_config[local.consul_inputs.presets.volume_permissions].limits.memory, "128Mi")
      )
    }
    exporter = {
      request_cpu = coalesce(
        var.consul_exporter_request_cpu,
        try(var.resources_config[local.consul_inputs.presets.exporter].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.consul_exporter_request_memory,
        try(var.resources_config[local.consul_inputs.presets.exporter].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.consul_exporter_limit_cpu,
        try(var.resources_config[local.consul_inputs.presets.exporter].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.consul_exporter_limit_memory,
        try(var.resources_config[local.consul_inputs.presets.exporter].limits.memory, "128Mi")
      )
    }
    name = "consul"
    // Services for Consul
    services = {
      metrics_service = {
        name = "consul-metrics"
        port = 9107
      }
      headless_service = {
        name = "consul-headless"
        port = 8500
      }
      ui_service = {
        name = "consul-ui"
        port = 80
      }
    }
  }
}

// =========================
// Consul outputs
// =========================
// Service port resolution and computed service information.
// These values depend on data sources and are separated to avoid dependency cycles.
locals {
  consul_outputs = {
    metrics_service = {
      host = "${data.kubernetes_service.consul_metrics.metadata[0].name}.${kubernetes_namespace.consul.metadata[0].name}.svc.cluster.local"
      port = local.consul.services.metrics_service.port
    }
    headless_service = {
      host = "${data.kubernetes_service.consul_headless.metadata[0].name}.${kubernetes_namespace.consul.metadata[0].name}.svc.cluster.local"
      port = local.consul.services.headless_service.port
    }
    ui_service = {
      host = "${data.kubernetes_service.consul_ui.metadata[0].name}.${kubernetes_namespace.consul.metadata[0].name}.svc.cluster.local"
      port = local.consul.services.ui_service.port
    }
  }
}
