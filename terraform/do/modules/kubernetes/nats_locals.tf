// =========================
// NATS inputs (preset 192)
// =========================
locals {
  nats_inputs = {
    presets = {
      nats = "192"
    }
  }
}

// =========================
// NATS computed values (size 192)
// =========================
locals {
  nats = {
    name = "nats"
    services = {
      service = {
        name = "nats"
        port = 4222
      }
      headless_service = {
        name = "nats-headless"
        port = 4222
      }
    }
    nats = {
      request_cpu    = coalesce(var.nats_request_cpu, try(var.resources_config[local.nats_inputs.presets.nats].requests.cpu, "192m"))
      request_memory = coalesce(var.nats_request_memory, try(var.resources_config[local.nats_inputs.presets.nats].requests.memory, "384Mi"))
      limit_cpu      = coalesce(var.nats_limit_cpu, try(var.resources_config[local.nats_inputs.presets.nats].limits.cpu, "3072m"))
      limit_memory   = coalesce(var.nats_limit_memory, try(var.resources_config[local.nats_inputs.presets.nats].limits.memory, "6144Mi"))
    }
  }
}

// =========================
// NATS outputs (for kani coordinator/executor: NATS_SERVER_1_HOST etc.)
// =========================
locals {
  nats_outputs = {
    service = {
      host = "${data.kubernetes_service.nats.metadata[0].name}.${kubernetes_namespace.nats.metadata[0].name}.svc.cluster.local"
      port = coalesce(
        try(
          one([
            for p in data.kubernetes_service.nats.spec[0].port :
            p.port if p.name == "client"
          ]),
          null
        ),
        local.nats.services.service.port
      )
    }
    headless_services = [
      for i in range(var.nats_replica_count) : {
        host = "nats-${i}.${data.kubernetes_service.nats_headless.metadata[0].name}.${kubernetes_namespace.nats.metadata[0].name}.svc.cluster.local"
        port = local.nats.services.service.port
      }
    ]
  }
}

// NATS env for kani-* (NATS_SERVERS_COUNT + NATS_SERVER_1..10_HOST/PORT)
// When replica_count is 1, headless_services[1..9] are out of range; fallback to service host/port.
// service.port can be null if no port named "client" exists, so coalesce with default 4222.
locals {
  nats_env = {
    servers_count  = var.nats_replica_count > 0 ? var.nats_replica_count : 1
    default_port   = local.nats.services.service.port
    server_hosts   = [for i in range(10) : try(local.nats_outputs.headless_services[i].host, local.nats_outputs.service.host)]
    server_ports   = [for i in range(10) : coalesce(try(local.nats_outputs.headless_services[i].port, local.nats_outputs.service.port), local.nats.services.service.port)]
  }
}
