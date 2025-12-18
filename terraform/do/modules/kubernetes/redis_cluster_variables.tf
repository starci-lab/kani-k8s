// =========================
// Redis Cluster enable variables
// =========================
// Controls whether the Redis Cluster is enabled.
variable "enable_redis_cluster" {
  type        = bool
  description = "Enable Redis Cluster"
  default     = true
}

// =========================
// Redis Cluster authentication variables
// =========================
// Defines authentication credentials used by clients and
// internal Redis nodes within the cluster.

variable "redis_password" {
  type        = string
  description = "Authentication password for the Redis Cluster"
  sensitive   = true
}

// =========================
// Redis Cluster topology variables
// =========================
// Controls the number of Redis nodes and replicas forming
// the Redis Cluster.

variable "redis_nodes" {
  type        = number
  description = "Total number of Redis nodes in the Redis Cluster"
  default     = 6
}

variable "redis_replicas" {
  type        = number
  description = "Number of replica nodes per Redis primary node"
  default     = 1
}

// =========================
// Redis Cluster resource requests and limits
// =========================
// Defines CPU and memory resource allocation for each Redis node.

variable "redis_request_cpu" {
  type        = string
  description = "CPU resource request for each Redis Cluster node"
  nullable    = true
  default     = null
}

variable "redis_request_memory" {
  type        = string
  description = "Memory resource request for each Redis Cluster node"
  nullable    = true
  default     = null
}

variable "redis_limit_cpu" {
  type        = string
  description = "CPU resource limit for each Redis Cluster node (2x request)"
  nullable    = true
  default     = null
}

variable "redis_limit_memory" {
  type        = string
  description = "Memory resource limit for each Redis Cluster node (2x request)"
  nullable    = true
  default     = null
}

// =========================
// Redis Cluster persistence variables
// =========================
// Defines persistent storage size for Redis data to ensure
// durability across pod restarts.

variable "redis_persistence_size" {
  type        = string
  description = "Persistent volume size for each Redis Cluster node"
  default     = "2Gi"
}

locals {
  redis_presets = {
    redis = "64"
  }
}

locals {
  redis = {
    redis = {
      request_cpu = coalesce(
        var.redis_request_cpu,
        try(var.resources_config[local.redis_presets.redis].requests.cpu, "96m")
      )
      request_memory = coalesce(
        var.redis_request_memory,
        try(var.resources_config[local.redis_presets.redis].requests.memory, "192Mi")
      )
      limit_cpu = coalesce(
        var.redis_limit_cpu,
        try(var.resources_config[local.redis_presets.redis].limits.cpu, "192m")
      )
      limit_memory = coalesce(
        var.redis_limit_memory,
        try(var.resources_config[local.redis_presets.redis].limits.memory, "384Mi")
      )
    }
  }
}