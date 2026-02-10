// =========================
// Kani Coordinator inputs
// =========================
// Preset mappings for Kani Coordinator components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
locals {
  kani_coordinator_inputs = {
    presets = {
      kani_coordinator = "32"
    }
  }
}

// =========================
// Kani Coordinator computed values
// =========================
// Resource requests and limits for Kani Coordinator components.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions.
locals {
  kani_coordinator = {
    kani_coordinator = {
      request_cpu = coalesce(
        var.kani_coordinator_request_cpu,
        try(var.resources_config[local.kani_coordinator_inputs.presets.kani_coordinator].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.kani_coordinator_request_memory,
        try(var.resources_config[local.kani_coordinator_inputs.presets.kani_coordinator].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.kani_coordinator_limit_cpu,
        try(var.resources_config[local.kani_coordinator_inputs.presets.kani_coordinator].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.kani_coordinator_limit_memory,
        try(var.resources_config[local.kani_coordinator_inputs.presets.kani_coordinator].limits.memory, "256Mi")
      )
    }
    name = "kani-coordinator"
    // Services for Kani Coordinator
    services = {
      server_service = {
        name = "kani-coordinator"
        port = 3000
      }
    }
  }
}
