// =========================
// Kani Executor inputs
// =========================
// Preset mappings for Kani Executor components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
locals {
  kani_executor_inputs = {
    presets = {
      kani_executor = "64"
    }
  }
}

// =========================
// Kani Executor computed values
// =========================
// Resource requests and limits for Kani Executor components.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming conventions.
locals {
  kani_executor = {
    kani_executor = {
      request_cpu = coalesce(
        var.kani_executor_request_cpu,
        try(var.resources_config[local.kani_executor_inputs.presets.kani_executor].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.kani_executor_request_memory,
        try(var.resources_config[local.kani_executor_inputs.presets.kani_executor].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.kani_executor_limit_cpu,
        try(var.resources_config[local.kani_executor_inputs.presets.kani_executor].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.kani_executor_limit_memory,
        try(var.resources_config[local.kani_executor_inputs.presets.kani_executor].limits.memory, "256Mi")
      )
    }
    name = "kani-executor"
    server_service_name = "kani-executor"
  }
}
