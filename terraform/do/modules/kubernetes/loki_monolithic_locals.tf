# // =========================
# // Loki Monolithic inputs
# // =========================
# // Preset mappings for Loki monolithic (SingleBinary).
# // Maps component to resource size key for preset lookup.
# locals {
#   loki_monolithic_inputs = {
#     presets = {
#       single_binary = "32"
#       canary        = "16"
#       gateway       = "32"
#     }
#   }
# }

# // =========================
# // Loki Monolithic computed values
# // =========================
# // Resource requests and limits for Loki monolithic single-binary.
# // Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
# // Also includes naming and services configuration.
# locals {
#   loki_monolithic = {
#     single_binary = {
#       request_cpu = coalesce(
#         var.loki_monolithic_request_cpu,
#         try(var.resources_config[local.loki_monolithic_inputs.presets.single_binary].requests.cpu, "200m")
#       )
#       request_memory = coalesce(
#         var.loki_monolithic_request_memory,
#         try(var.resources_config[local.loki_monolithic_inputs.presets.single_binary].requests.memory, "256Mi")
#       )
#       limit_cpu = coalesce(
#         var.loki_monolithic_limit_cpu,
#         try(var.resources_config[local.loki_monolithic_inputs.presets.single_binary].limits.cpu, "500m")
#       )
#       limit_memory = coalesce(
#         var.loki_monolithic_limit_memory,
#         try(var.resources_config[local.loki_monolithic_inputs.presets.single_binary].limits.memory, "512Mi")
#       )
#     }
#     name = "loki-monolithic"
#     // Services for Loki Monolithic (Grafana chart single-binary creates this service)
#     services = {
#       loki_monolithic = {
#         name = "loki-monolithic"
#         port = 3100
#       }
#       gateway_service = {
#         name = "loki-monolithic-gateway"
#         port = 80
#       }
#     }
#   }
#   loki_monolithic_canary = {
#     request_cpu = coalesce(
#       var.loki_monolithic_canary_request_cpu,
#       try(var.resources_config[local.loki_monolithic_inputs.presets.canary].requests.cpu, "200m")
#     )
#     request_memory = coalesce(
#       var.loki_monolithic_canary_request_memory,
#       try(var.resources_config[local.loki_monolithic_inputs.presets.canary].requests.memory, "256Mi")
#     )
#     limit_cpu = coalesce(
#       var.loki_monolithic_canary_limit_cpu,
#       try(var.resources_config[local.loki_monolithic_inputs.presets.canary].limits.cpu, "500m")
#     )
#     limit_memory = coalesce(
#       var.loki_monolithic_canary_limit_memory,
#       try(var.resources_config[local.loki_monolithic_inputs.presets.canary].limits.memory, "512Mi")
#     )
#   }
#   loki_monolithic_gateway = {
#     request_cpu = coalesce(
#       var.loki_monolithic_gateway_request_cpu,
#       try(var.resources_config[local.loki_monolithic_inputs.presets.gateway].requests.cpu, "100m")
#     )
#     request_memory = coalesce(
#       var.loki_monolithic_gateway_request_memory,
#       try(var.resources_config[local.loki_monolithic_inputs.presets.gateway].requests.memory, "128Mi")
#     )
#     limit_cpu = coalesce(
#       var.loki_monolithic_gateway_limit_cpu,
#       try(var.resources_config[local.loki_monolithic_inputs.presets.gateway].limits.cpu, "200m")
#     )
#     limit_memory = coalesce(
#       var.loki_monolithic_gateway_limit_memory,
#       try(var.resources_config[local.loki_monolithic_inputs.presets.gateway].limits.memory, "256Mi")
#     )
#   }
# }

# // =========================
# // Loki Monolithic outputs
# // =========================
# // Service host and port for Loki monolithic single-binary.
# // Depends on data source from loki_monolithic_resources_networking.tf.
# locals {
#   loki_monolithic_outputs = {
#     loki_monolithic = {
#       host = "${data.kubernetes_service.loki_monolithic.metadata[0].name}.${kubernetes_namespace.loki.metadata[0].name}.svc.cluster.local"
#       port = try(
#         one([
#           for p in data.kubernetes_service.loki_monolithic.spec[0].port :
#           p.port if p.port == local.loki_monolithic.services.loki_monolithic.port
#         ]),
#         data.kubernetes_service.loki_monolithic.spec[0].port[0].port
#       )
#     }
#     gateway_service = {
#       host = "${data.kubernetes_service.loki_monolithic_gateway.metadata[0].name}.${kubernetes_namespace.loki.metadata[0].name}.svc.cluster.local"
#       port = try(
#         one([
#           for p in data.kubernetes_service.loki_monolithic_gateway.spec[0].port :
#           p.port if p.port == local.loki_monolithic.services.gateway_service.port
#         ]),
#         data.kubernetes_service.loki_monolithic_gateway.spec[0].port[0].port
#       )
#     }
#   }
# }
