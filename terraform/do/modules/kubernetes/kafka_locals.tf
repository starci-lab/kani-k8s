// =========================
// Kafka inputs
// =========================
// Preset mappings for Kafka components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
locals {
  kafka_inputs = {
    presets = {
      controller        = "192"
      broker            = "192"
      volume_permissions = "16"
      kafka_ui          = "64"
    }
  }
}

// =========================
// Kafka computed values
// =========================
// Resource requests and limits for Kafka components.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes service configuration for Kafka and Kafka UI.
locals {
  kafka = {
    controller = {
      request_cpu = coalesce(
        var.kafka_controller_request_cpu,
        try(var.resources_config[local.kafka_inputs.presets.controller].requests.cpu, "192m")
      )
      request_memory = coalesce(
        var.kafka_controller_request_memory,
        try(var.resources_config[local.kafka_inputs.presets.controller].requests.memory, "384Mi")
      )
      limit_cpu = coalesce(
        var.kafka_controller_limit_cpu,
        try(var.resources_config[local.kafka_inputs.presets.controller].limits.cpu, "768m")
      )
      limit_memory = coalesce(
        var.kafka_controller_limit_memory,
        try(var.resources_config[local.kafka_inputs.presets.controller].limits.memory, "1536Mi")
      )
    }
    broker = {
      request_cpu = coalesce(
        var.kafka_broker_request_cpu,
        try(var.resources_config[local.kafka_inputs.presets.broker].requests.cpu, "192m")
      )
      request_memory = coalesce(
        var.kafka_broker_request_memory,
        try(var.resources_config[local.kafka_inputs.presets.broker].requests.memory, "384Mi")
      )
      limit_cpu = coalesce(
        var.kafka_broker_limit_cpu,
        try(var.resources_config[local.kafka_inputs.presets.broker].limits.cpu, "768m")
      )
      limit_memory = coalesce(
        var.kafka_broker_limit_memory,
        try(var.resources_config[local.kafka_inputs.presets.broker].limits.memory, "1536Mi")
      )
    }
    volume_permissions = {
      request_cpu = coalesce(
        var.volume_permissions_request_cpu,
        try(var.resources_config[local.kafka_inputs.presets.volume_permissions].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.volume_permissions_request_memory,
        try(var.resources_config[local.kafka_inputs.presets.volume_permissions].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.volume_permissions_limit_cpu,
        try(var.resources_config[local.kafka_inputs.presets.volume_permissions].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.volume_permissions_limit_memory,
        try(var.resources_config[local.kafka_inputs.presets.volume_permissions].limits.memory, "256Mi")
      )
    }
    kafka_ui = {
      request_cpu = coalesce(
        var.kafka_ui_request_cpu,
        try(var.resources_config[local.kafka_inputs.presets.kafka_ui].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.kafka_ui_request_memory,
        try(var.resources_config[local.kafka_inputs.presets.kafka_ui].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.kafka_ui_limit_cpu,
        try(var.resources_config[local.kafka_inputs.presets.kafka_ui].limits.cpu, "32m")
      )
      limit_memory = coalesce(
        var.kafka_ui_limit_memory,
        try(var.resources_config[local.kafka_inputs.presets.kafka_ui].limits.memory, "64Mi")
      )
    }
    name = "kafka"
    // Services for Kafka
    services = {
      service = {
        name = "kafka"
        port = 9092
      }
      ui_service = {
        name = "kafka-ui"
        port = 8080
      }
    }
  }
}

// =========================
// Kafka outputs
// =========================
// Service port resolution and computed service information.
// These values depend on data sources and are separated to avoid dependency cycles.
locals {
  kafka_outputs = {
    service = {
      host = "${data.kubernetes_service.kafka.metadata[0].name}.${kubernetes_namespace.kafka.metadata[0].name}.svc.cluster.local"
      port = try(
        one([
          for p in data.kubernetes_service.kafka.spec[0].port :
          p.port if p.port == local.kafka.services.service.port
        ]),
        data.kubernetes_service.kafka.spec[0].port[0].port
      )
    }
    ui_service = {
      host = "${data.kubernetes_service.kafka_ui.metadata[0].name}.${kubernetes_namespace.kafka.metadata[0].name}.svc.cluster.local"
      port = try(
        one([
          for p in data.kubernetes_service.kafka_ui.spec[0].port :
          p.port if p.port == local.kafka.services.ui_service.port
        ]),
        data.kubernetes_service.kafka_ui.spec[0].port[0].port
      )
    }
  }
}
