// =========================
// Prometheus inputs
// =========================
// Preset mappings for Prometheus components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
locals {
  prometheus_inputs = {
    presets = {
      operator          = "16"
      prometheus        = "32"
      thanos            = "16"
      alertmanager      = "16"
      blackbox_exporter = "16"
      thanos_ruler      = "16"
    }
  }
}

// =========================
// Prometheus computed values
// =========================
// Resource requests and limits for Prometheus components.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions.
locals {
  prometheus = {
    operator = {
      request_cpu = coalesce(
        var.operator_request_cpu,
        try(var.resources_config[local.prometheus_inputs.presets.operator].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.operator_request_memory,
        try(var.resources_config[local.prometheus_inputs.presets.operator].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.operator_limit_cpu,
        try(var.resources_config[local.prometheus_inputs.presets.operator].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.operator_limit_memory,
        try(var.resources_config[local.prometheus_inputs.presets.operator].limits.memory, "512Mi")
      )
    }
    prometheus = {
      request_cpu = coalesce(
        var.prometheus_request_cpu,
        try(var.resources_config[local.prometheus_inputs.presets.prometheus].requests.cpu, "64m")
      )
      request_memory = coalesce(
        var.prometheus_request_memory,
        try(var.resources_config[local.prometheus_inputs.presets.prometheus].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.prometheus_limit_cpu,
        try(var.resources_config[local.prometheus_inputs.presets.prometheus].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.prometheus_limit_memory,
        try(var.resources_config[local.prometheus_inputs.presets.prometheus].limits.memory, "512Mi")
      )
    }
    thanos = {
      request_cpu = coalesce(
        var.thanos_request_cpu,
        try(var.resources_config[local.prometheus_inputs.presets.thanos].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.thanos_request_memory,
        try(var.resources_config[local.prometheus_inputs.presets.thanos].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.thanos_limit_cpu,
        try(var.resources_config[local.prometheus_inputs.presets.thanos].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.thanos_limit_memory,
        try(var.resources_config[local.prometheus_inputs.presets.thanos].limits.memory, "256Mi")
      )
    }
    alertmanager = {
      request_cpu = coalesce(
        var.alertmanager_request_cpu,
        try(var.resources_config[local.prometheus_inputs.presets.alertmanager].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.alertmanager_request_memory,
        try(var.resources_config[local.prometheus_inputs.presets.alertmanager].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.alertmanager_limit_cpu,
        try(var.resources_config[local.prometheus_inputs.presets.alertmanager].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.alertmanager_limit_memory,
        try(var.resources_config[local.prometheus_inputs.presets.alertmanager].limits.memory, "256Mi")
      )
    }
    blackbox_exporter = {
      request_cpu = coalesce(
        var.blackbox_exporter_request_cpu,
        try(var.resources_config[local.prometheus_inputs.presets.blackbox_exporter].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.blackbox_exporter_request_memory,
        try(var.resources_config[local.prometheus_inputs.presets.blackbox_exporter].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.blackbox_exporter_limit_cpu,
        try(var.resources_config[local.prometheus_inputs.presets.blackbox_exporter].limits.cpu, "64m")
      )
      limit_memory = coalesce(
        var.blackbox_exporter_limit_memory,
        try(var.resources_config[local.prometheus_inputs.presets.blackbox_exporter].limits.memory, "128Mi")
      )
    }
    thanos_ruler = {
      request_cpu = coalesce(
        var.thanos_ruler_request_cpu,
        try(var.resources_config[local.prometheus_inputs.presets.thanos_ruler].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.thanos_ruler_request_memory,
        try(var.resources_config[local.prometheus_inputs.presets.thanos_ruler].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.thanos_ruler_limit_cpu,
        try(var.resources_config[local.prometheus_inputs.presets.thanos_ruler].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.thanos_ruler_limit_memory,
        try(var.resources_config[local.prometheus_inputs.presets.thanos_ruler].limits.memory, "256Mi")
      )
    }
    name = "kube-prometheus"
    // Services for Prometheus
    services = {
      server_service = {
        name = "kube-prometheus-prometheus"
        port = 9090
      }
      alertmanager_server_service = {
        name = "kube-prometheus-alertmanager"
        port = 9093
      }
    }
  }
}

// =========================
// Prometheus outputs
// =========================
// Service port resolution and computed service information.
// These values depend on data sources and are separated to avoid dependency cycles.
locals {
  prometheus_outputs = {
    server_service = {
      host = "${data.kubernetes_service.prometheus_server.metadata[0].name}.${kubernetes_namespace.prometheus.metadata[0].name}.svc.cluster.local"
      port = try(
        one([
          for p in data.kubernetes_service.prometheus_server.spec[0].port :
          p.port if p.port == local.prometheus.services.server_service.port
        ]),
        data.kubernetes_service.prometheus_server.spec[0].port[0].port
      )
    }
    alertmanager_server_service = {
      host = "${data.kubernetes_service.prometheus_alertmanager_server.metadata[0].name}.${kubernetes_namespace.prometheus.metadata[0].name}.svc.cluster.local"
      port = try(
        one([
          for p in data.kubernetes_service.prometheus_alertmanager_server.spec[0].port :
          p.port if p.port == local.prometheus.services.alertmanager_server_service.port
        ]),
        data.kubernetes_service.prometheus_alertmanager_server.spec[0].port[0].port
      )
    }
  }
}
