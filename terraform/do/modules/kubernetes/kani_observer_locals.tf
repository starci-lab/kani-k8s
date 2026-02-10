// =========================
// Kani Observer inputs
// =========================
// Preset mappings for Kani Observer components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
locals {
  kani_observer_inputs = {
    presets = {
      kani_observer = "64"
    }
  }
}

// =========================
// Kani Observer computed values
// =========================
// Resource requests and limits for Kani Observer components.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions.
locals {
  kani_observer = {
    kani_observer = {
      request_cpu = coalesce(
        var.kani_observer_request_cpu,
        try(var.resources_config[local.kani_observer_inputs.presets.kani_observer].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.kani_observer_request_memory,
        try(var.resources_config[local.kani_observer_inputs.presets.kani_observer].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.kani_observer_limit_cpu,
        try(var.resources_config[local.kani_observer_inputs.presets.kani_observer].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.kani_observer_limit_memory,
        try(var.resources_config[local.kani_observer_inputs.presets.kani_observer].limits.memory, "256Mi")
      )
    }
    name = "kani-observer"
    // Services for Kani Observer
    services = {
      server_service = {
        name = "kani-observer"
        port = 3000
      }
    }
  }
}
