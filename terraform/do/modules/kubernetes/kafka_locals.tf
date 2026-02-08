// =========================
// Kafka computed values
// =========================
// Resource requests and limits for Kafka components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes service configuration for Kafka and Kafka UI.

locals {
  kafka = {
    presets = {
      controller        = "192"
      broker            = "192"
      volume_permissions = "16"
      kafka_ui          = "64"
    }
    controller = {
      request_cpu = coalesce(
        var.kafka_controller_request_cpu,
        try(var.resources_config[local.kafka.presets.controller].requests.cpu, "192m")
      )
      request_memory = coalesce(
        var.kafka_controller_request_memory,
        try(var.resources_config[local.kafka.presets.controller].requests.memory, "384Mi")
      )
      limit_cpu = coalesce(
        var.kafka_controller_limit_cpu,
        try(var.resources_config[local.kafka.presets.controller].limits.cpu, "768m")
      )
      limit_memory = coalesce(
        var.kafka_controller_limit_memory,
        try(var.resources_config[local.kafka.presets.controller].limits.memory, "1536Mi")
      )
    }
    broker = {
      request_cpu = coalesce(
        var.kafka_broker_request_cpu,
        try(var.resources_config[local.kafka.presets.broker].requests.cpu, "192m")
      )
      request_memory = coalesce(
        var.kafka_broker_request_memory,
        try(var.resources_config[local.kafka.presets.broker].requests.memory, "384Mi")
      )
      limit_cpu = coalesce(
        var.kafka_broker_limit_cpu,
        try(var.resources_config[local.kafka.presets.broker].limits.cpu, "768m")
      )
      limit_memory = coalesce(
        var.kafka_broker_limit_memory,
        try(var.resources_config[local.kafka.presets.broker].limits.memory, "1536Mi")
      )
    }
    volume_permissions = {
      request_cpu = coalesce(
        var.volume_permissions_request_cpu,
        try(var.resources_config[local.kafka.presets.volume_permissions].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.volume_permissions_request_memory,
        try(var.resources_config[local.kafka.presets.volume_permissions].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.volume_permissions_limit_cpu,
        try(var.resources_config[local.kafka.presets.volume_permissions].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.volume_permissions_limit_memory,
        try(var.resources_config[local.kafka.presets.volume_permissions].limits.memory, "256Mi")
      )
    }
    kafka_ui = {
      request_cpu = coalesce(
        var.kafka_ui_request_cpu,
        try(var.resources_config[local.kafka.presets.kafka_ui].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.kafka_ui_request_memory,
        try(var.resources_config[local.kafka.presets.kafka_ui].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.kafka_ui_limit_cpu,
        try(var.resources_config[local.kafka.presets.kafka_ui].limits.cpu, "32m")
      )
      limit_memory = coalesce(
        var.kafka_ui_limit_memory,
        try(var.resources_config[local.kafka.presets.kafka_ui].limits.memory, "64Mi")
      )
    }
    service = {
      host = "${data.kubernetes_service.kafka.metadata[0].name}.${kubernetes_namespace.kafka.metadata[0].name}.svc.cluster.local"
      port = 9092
    }
    ui_service = {
      host = "kafka-ui.${kubernetes_namespace.kafka.metadata[0].name}.svc.cluster.local"
      port = 8080
    }
  }
}
