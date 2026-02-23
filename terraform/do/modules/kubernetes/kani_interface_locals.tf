// =========================
// Kani Interface inputs
// =========================
// Preset mappings for Kani Interface components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
locals {
  kani_interface_inputs = {
    presets = {
      kani_interface = "96"
    }
  }
}

// =========================
// Kani Interface computed values
// =========================
// Resource requests and limits for Kani Interface components.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions.
locals {
  kani_interface = {
    kani_interface = {
      request_cpu = coalesce(
        var.kani_interface_request_cpu,
        try(var.resources_config[local.kani_interface_inputs.presets.kani_interface].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.kani_interface_request_memory,
        try(var.resources_config[local.kani_interface_inputs.presets.kani_interface].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.kani_interface_limit_cpu,
        try(var.resources_config[local.kani_interface_inputs.presets.kani_interface].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.kani_interface_limit_memory,
        try(var.resources_config[local.kani_interface_inputs.presets.kani_interface].limits.memory, "256Mi")
      )
    }
    name = "kani-interface"
    // Services for Kani Interface
    services = {
      server_service = {
        name = "kani-interface"
        port = 3000
      }
    }
  }
}
