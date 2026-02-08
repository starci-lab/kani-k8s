// =========================
// Consul computed values
// =========================
// Resource requests and limits for Consul components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions and service configuration.

locals {
  consul = {
    presets = {
      consul             = "64"
      volume_permissions = "16"
    }
    consul = {
      request_cpu = coalesce(
        var.consul_request_cpu,
        try(var.resources_config[local.consul.presets.consul].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.consul_request_memory,
        try(var.resources_config[local.consul.presets.consul].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.consul_limit_cpu,
        try(var.resources_config[local.consul.presets.consul].limits.cpu, "256m")
      )
      limit_memory = coalesce(
        var.consul_limit_memory,
        try(var.resources_config[local.consul.presets.consul].limits.memory, "256Mi")
      )
    }
    volume_permissions = {
      request_cpu = coalesce(
        var.consul_volume_permissions_request_cpu,
        try(var.resources_config[local.consul.presets.volume_permissions].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.consul_volume_permissions_request_memory,
        try(var.resources_config[local.consul.presets.volume_permissions].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.consul_volume_permissions_limit_cpu,
        try(var.resources_config[local.consul.presets.volume_permissions].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.consul_volume_permissions_limit_memory,
        try(var.resources_config[local.consul.presets.volume_permissions].limits.memory, "128Mi")
      )
    }
    name = "consul"
    server_service_name = "consul"
    service = {
      host = "${data.kubernetes_service.consul.metadata[0].name}.${kubernetes_namespace.consul.metadata[0].name}.svc.cluster.local"
      port = 80
    }
  }
}
