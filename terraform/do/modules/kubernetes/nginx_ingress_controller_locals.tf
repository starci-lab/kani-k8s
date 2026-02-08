// =========================
// NGINX Ingress Controller computed values
// =========================
// Resource requests and limits for NGINX Ingress Controller components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions.

locals {
  nginx_ingress_controller = {
    presets = {
      controller      = "32"
      default_backend = "16"
    }
    controller = {
      request_cpu = coalesce(
        var.nginx_ingress_controller_request_cpu,
        try(var.resources_config[local.nginx_ingress_controller.presets.controller].requests.cpu, "64m")
      )
      request_memory = coalesce(
        var.nginx_ingress_controller_request_memory,
        try(var.resources_config[local.nginx_ingress_controller.presets.controller].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.nginx_ingress_controller_limit_cpu,
        try(var.resources_config[local.nginx_ingress_controller.presets.controller].limits.cpu, "256m")
      )
      limit_memory = coalesce(
        var.nginx_ingress_controller_limit_memory,
        try(var.resources_config[local.nginx_ingress_controller.presets.controller].limits.memory, "512Mi")
      )
    }
    default_backend = {
      request_cpu = coalesce(
        var.nginx_ingress_controller_default_backend_request_cpu,
        try(var.resources_config[local.nginx_ingress_controller.presets.default_backend].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.nginx_ingress_controller_default_backend_request_memory,
        try(var.resources_config[local.nginx_ingress_controller.presets.default_backend].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.nginx_ingress_controller_default_backend_limit_cpu,
        try(var.resources_config[local.nginx_ingress_controller.presets.default_backend].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.nginx_ingress_controller_default_backend_limit_memory,
        try(var.resources_config[local.nginx_ingress_controller.presets.default_backend].limits.memory, "256Mi")
      )
    }
    name = "nginx-ingress-controller"
  }
}
