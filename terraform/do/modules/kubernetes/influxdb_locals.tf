// =========================
// InfluxDB inputs
// =========================
// Preset mappings for InfluxDB. Maps component to resource size key for preset lookup.
locals {
  influxdb_inputs = {
    presets = {
      influxdb = "128"
    }
  }
}

// =========================
// InfluxDB computed values
// =========================
// Resource requests and limits for InfluxDB.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
// Also includes naming and services configuration.
locals {
  influxdb = {
    influxdb = {
      request_cpu = coalesce(
        var.influxdb_request_cpu,
        try(var.resources_config[local.influxdb_inputs.presets.influxdb].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.influxdb_request_memory,
        try(var.resources_config[local.influxdb_inputs.presets.influxdb].requests.memory, "256Mi")
      )
      limit_cpu = coalesce(
        var.influxdb_limit_cpu,
        try(var.resources_config[local.influxdb_inputs.presets.influxdb].limits.cpu, "500m")
      )
      limit_memory = coalesce(
        var.influxdb_limit_memory,
        try(var.resources_config[local.influxdb_inputs.presets.influxdb].limits.memory, "512Mi")
      )
    }
    name = "influxdb"
    // Services for InfluxDB (Bitnami chart creates service with HTTP port 8181)
    services = {
      server_service = {
        name = "influxdb"
        port = 8181
      }
    }
  }
}

// =========================
// InfluxDB outputs
// =========================
// Service host and port for InfluxDB. Depends on data source from influxdb_resources_networking.tf.
locals {
  influxdb_outputs = {
    server_service = {
      host = "${data.kubernetes_service.influxdb.metadata[0].name}.${kubernetes_namespace.influxdb.metadata[0].name}.svc.cluster.local"
      port = try(
        one([
          for p in data.kubernetes_service.influxdb.spec[0].port :
          p.port if p.port == local.influxdb.services.server_service.port
        ]),
        data.kubernetes_service.influxdb.spec[0].port[0].port
      )
    }
  }
}

// =========================
// InfluxDB secret
// =========================
// Secret for InfluxDB. Depends on data source from influxdb_resources_networking.tf.
locals {
  influxdb_secret = {
    token = data.kubernetes_secret.influxdb.data["admin-token"]
  }
}