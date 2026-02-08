// =========================
// MongoDB Sharded computed values
// =========================
// Resource requests and limits for MongoDB Sharded components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes service configuration.

locals {
  mongodb = {
    presets = {
      configsvr = "64"
      shardsvr  = "192"
      mongos    = "64"
    }
    configsvr = {
      request_cpu = coalesce(
        var.mongodb_configsvr_request_cpu,
        try(var.resources_config[local.mongodb.presets.configsvr].requests.cpu, "96m")
      )
      request_memory = coalesce(
        var.mongodb_configsvr_request_memory,
        try(var.resources_config[local.mongodb.presets.configsvr].requests.memory, "192Mi")
      )
      limit_cpu = coalesce(
        var.mongodb_configsvr_limit_cpu,
        try(var.resources_config[local.mongodb.presets.configsvr].limits.cpu, "256m")
      )
      limit_memory = coalesce(
        var.mongodb_configsvr_limit_memory,
        try(var.resources_config[local.mongodb.presets.configsvr].limits.memory, "512Mi")
      )
    }
    shardsvr = {
      request_cpu = coalesce(
        var.mongodb_shardsvr_request_cpu,
        try(var.resources_config[local.mongodb.presets.shardsvr].requests.cpu, "192m")
      )
      request_memory = coalesce(
        var.mongodb_shardsvr_request_memory,
        try(var.resources_config[local.mongodb.presets.shardsvr].requests.memory, "384Mi")
      )
      limit_cpu = coalesce(
        var.mongodb_shardsvr_limit_cpu,
        try(var.resources_config[local.mongodb.presets.shardsvr].limits.cpu, "768m")
      )
      limit_memory = coalesce(
        var.mongodb_shardsvr_limit_memory,
        try(var.resources_config[local.mongodb.presets.shardsvr].limits.memory, "1536Mi")
      )
    }
    mongos = {
      request_cpu = coalesce(
        var.mongodb_request_cpu,
        try(var.resources_config[local.mongodb.presets.mongos].requests.cpu, "96m")
      )
      request_memory = coalesce(
        var.mongodb_request_memory,
        try(var.resources_config[local.mongodb.presets.mongos].requests.memory, "192Mi")
      )
      limit_cpu = coalesce(
        var.mongodb_limit_cpu,
        try(var.resources_config[local.mongodb.presets.mongos].limits.cpu, "384m")
      )
      limit_memory = coalesce(
        var.mongodb_limit_memory,
        try(var.resources_config[local.mongodb.presets.mongos].limits.memory, "768Mi")
      )
    }
    service = {
      host = "${data.kubernetes_service.mongodb_sharded.metadata[0].name}.${kubernetes_namespace.mongodb_sharded.metadata[0].name}.svc.cluster.local"
      port = 27017
    }
  }
}
