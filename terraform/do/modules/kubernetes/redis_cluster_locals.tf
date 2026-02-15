# // =========================
# // Redis Cluster inputs
# // =========================
# // Preset mappings for Redis Cluster components.
# // Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
# locals {
#   redis_cluster_inputs = {
#     presets = {
#       redis = "64"
#     }
#   }
# }

# // =========================
# // Redis Cluster computed values
# // =========================
# // Resource requests and limits for Redis Cluster components.
# // Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
# // Also includes naming conventions.
# locals {
#   redis_cluster = {
#     redis = {
#       request_cpu = coalesce(
#         var.redis_request_cpu,
#         try(var.resources_config[local.redis_cluster_inputs.presets.redis].requests.cpu, "96m")
#       )
#       request_memory = coalesce(
#         var.redis_request_memory,
#         try(var.resources_config[local.redis_cluster_inputs.presets.redis].requests.memory, "192Mi")
#       )
#       limit_cpu = coalesce(
#         var.redis_limit_cpu,
#         try(var.resources_config[local.redis_cluster_inputs.presets.redis].limits.cpu, "192m")
#       )
#       limit_memory = coalesce(
#         var.redis_limit_memory,
#         try(var.resources_config[local.redis_cluster_inputs.presets.redis].limits.memory, "384Mi")
#       )
#     }
#     name = "redis-cluster"
#     // Services for Redis Cluster
#     services = {
#       service = {
#         name = "redis-cluster"
#         port = 6379
#       }
#     }
#   }
# }

# // =========================
# // Redis Cluster outputs
# // =========================
# // Service port resolution and computed service information.
# // These values depend on data sources and are separated to avoid dependency cycles.
# locals {
#   redis_standalone_outputs = {
#     service = {
#       host = "${data.kubernetes_service.redis_cluster.metadata[0].name}.${kubernetes_namespace.redis_cluster.metadata[0].name}.svc.cluster.local"
#       port = try(
#         one([
#           for p in data.kubernetes_service.redis_cluster.spec[0].port :
#           p.port if p.port == local.redis_cluster.services.service.port
#         ]),
#         data.kubernetes_service.redis_cluster.spec[0].port[0].port
#       )
#     }
#   }
# }
