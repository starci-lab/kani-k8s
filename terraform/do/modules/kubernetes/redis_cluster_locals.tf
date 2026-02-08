// =========================
// Redis Cluster computed values
// =========================
// Resource requests and limits for Redis Cluster components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions and service configuration.

locals {
  redis_cluster = {
    presets = {
      redis = "64"
    }
    redis = {
      request_cpu = coalesce(
        var.redis_request_cpu,
        try(var.resources_config[local.redis_cluster.presets.redis].requests.cpu, "96m")
      )
      request_memory = coalesce(
        var.redis_request_memory,
        try(var.resources_config[local.redis_cluster.presets.redis].requests.memory, "192Mi")
      )
      limit_cpu = coalesce(
        var.redis_limit_cpu,
        try(var.resources_config[local.redis_cluster.presets.redis].limits.cpu, "192m")
      )
      limit_memory = coalesce(
        var.redis_limit_memory,
        try(var.resources_config[local.redis_cluster.presets.redis].limits.memory, "384Mi")
      )
    }
    name = "redis-cluster"
    service = {
      host = "${data.kubernetes_service.redis_cluster.metadata[0].name}.${kubernetes_namespace.redis_cluster.metadata[0].name}.svc.cluster.local"
      port = 6379
    }
  }
}
