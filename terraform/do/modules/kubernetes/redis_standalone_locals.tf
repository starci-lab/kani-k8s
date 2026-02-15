// =========================
// Redis Standalone inputs
// =========================
// Preset mappings for Redis Standalone components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
locals {
  redis_standalone_inputs = {
    presets = {
      redis = "128"
    }
  }
}

// =========================
// Redis Standalone computed values
// =========================
// Resource requests and limits for Redis Standalone components.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions.
locals {
  redis_standalone = {
    master = {
      request_cpu = coalesce(
        var.redis_standalone_master_request_cpu,
        try(var.resources_config[local.redis_standalone_inputs.presets.redis].requests.cpu, "96m")
      )
      request_memory = coalesce(
        var.redis_standalone_master_request_memory,
        try(var.resources_config[local.redis_standalone_inputs.presets.redis].requests.memory, "192Mi")
      )
      limit_cpu = coalesce(
        var.redis_standalone_master_limit_cpu,
        try(var.resources_config[local.redis_standalone_inputs.presets.redis].limits.cpu, "192m")
      )
      limit_memory = coalesce(
        var.redis_standalone_master_limit_memory,
        try(var.resources_config[local.redis_standalone_inputs.presets.redis].limits.memory, "384Mi")
      )
    }
    replica = {
      replica_count = var.redis_standalone_replica_count
      request_cpu = coalesce(
        var.redis_standalone_replica_request_cpu,
        try(var.resources_config[local.redis_standalone_inputs.presets.redis].requests.cpu, "96m")
      )
      request_memory = coalesce(
        var.redis_standalone_replica_request_memory,
        try(var.resources_config[local.redis_standalone_inputs.presets.redis].requests.memory, "192Mi")
      )
      limit_cpu = coalesce(
        var.redis_standalone_replica_limit_cpu,
        try(var.resources_config[local.redis_standalone_inputs.presets.redis].limits.cpu, "192m")
      )
      limit_memory = coalesce(
        var.redis_standalone_replica_limit_memory,
        try(var.resources_config[local.redis_standalone_inputs.presets.redis].limits.memory, "384Mi")
      )
    }
    name = "redis-standalone"
    // Services for Redis Standalone
    services = {
      service = {
        name = "redis-standalone-master"
        port = 6379
      }
    }
  }
}

// =========================
// Redis Standalone outputs
// =========================
// Service port resolution and computed service information.
// These values depend on data sources and are separated to avoid dependency cycles.
locals {
  redis_standalone_outputs = {
    service = {
      host = "${data.kubernetes_service.redis_standalone.metadata[0].name}.${kubernetes_namespace.redis_standalone.metadata[0].name}.svc.cluster.local"
      port = try(
        one([
          for p in data.kubernetes_service.redis_standalone.spec[0].port :
          p.port if p.port == local.redis_standalone.services.service.port
        ]),
        data.kubernetes_service.redis_standalone.spec[0].port[0].port
      )
    }
  }
}
