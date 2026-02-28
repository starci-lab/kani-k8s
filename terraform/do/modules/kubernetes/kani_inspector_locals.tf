// =========================
// Kani Inspector inputs
// =========================
// Preset mappings for Kani Inspector components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
locals {
  kani_inspector_inputs = {
    presets = {
      kani_inspector = "96"
    }
  }
}

// =========================
// Kani Inspector computed values
// =========================
// Resource requests and limits for Kani Inspector components.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions.
locals {
  kani_inspector = {
    kani_inspector = {
      request_cpu = coalesce(
        var.kani_inspector_request_cpu,
        try(var.resources_config[local.kani_inspector_inputs.presets.kani_inspector].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.kani_inspector_request_memory,
        try(var.resources_config[local.kani_inspector_inputs.presets.kani_inspector].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.kani_inspector_limit_cpu,
        try(var.resources_config[local.kani_inspector_inputs.presets.kani_inspector].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.kani_inspector_limit_memory,
        try(var.resources_config[local.kani_inspector_inputs.presets.kani_inspector].limits.memory, "256Mi")
      )
    }
    name = "kani-inspector"
    // Services for Kani Inspector
    services = {
      server_service = {
        name = "kani-inspector"
        port = 3000
      }
    }
  }
}
