// =========================
// Kani CLI inputs
// =========================
// Preset mappings for Kani CLI components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
locals {
  kani_cli_inputs = {
    presets = {
      kani_cli = "64"
    }
  }
}

// =========================
// Kani CLI computed values
// =========================
// Resource requests and limits for Kani CLI components.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions.
locals {
  kani_cli = {
    kani_cli = {
      request_cpu = coalesce(
        var.kani_cli_request_cpu,
        try(var.resources_config[local.kani_cli_inputs.presets.kani_cli].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.kani_cli_request_memory,
        try(var.resources_config[local.kani_cli_inputs.presets.kani_cli].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.kani_cli_limit_cpu,
        try(var.resources_config[local.kani_cli_inputs.presets.kani_cli].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.kani_cli_limit_memory,
        try(var.resources_config[local.kani_cli_inputs.presets.kani_cli].limits.memory, "256Mi")
      )
    }
    name = "kani-cli"
    // Services for Kani CLI
    services = {
      server_service = {
        name = "kani-cli"
        port = 3000
      }
    }
    service_env_vars_name = "kani-cli-service-env-vars"
  }
}
