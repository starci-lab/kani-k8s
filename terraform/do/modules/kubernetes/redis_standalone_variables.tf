// =========================
// Redis Standalone authentication variables
// =========================
// Defines authentication credentials used by clients and
// internal Redis nodes within the cluster.

// Authentication password for the Redis Standalone
variable "redis_standalone_password" {
  type        = string
  description = "Authentication password for the Redis Standalone"
  sensitive   = true
}

// =========================
// Redis Standalone topology variables
// =========================
// Controls the number of Redis nodes and replicas forming
// the Redis Standalone.

// CPU resource request for each Redis Standalone node
variable "redis_standalone_master_request_cpu" {
  type        = string
  description = "CPU resource request for Redis Standalone node"
  nullable    = true
  default     = null
}

// Memory resource request for Redis Standalone node
variable "redis_standalone_master_request_memory" {
  type        = string
  description = "Memory resource request for Redis Standalone master node"
  nullable    = true
  default     = null
}

// CPU resource limit for each Redis Standalone node
variable "redis_standalone_master_limit_cpu" {
  type        = string
  description = "CPU resource limit for each Redis Standalone master node"
  nullable    = true
  default     = null
}

// Memory resource limit for each Redis Standalone node
variable "redis_standalone_master_limit_memory" {
  type        = string
  description = "Memory resource limit for each Redis Standalone master node"
  nullable    = true
  default     = null
}
// =========================
// Redis Standalone replica variables
// =========================
// Controls the number of Redis replica nodes forming
// the Redis Standalone.

// Number of replica nodes for Redis Standalone
variable "redis_standalone_replica_count" {
  type        = number
  description = "Number of replica nodes for Redis Standalone"
  default     = 0
}

// CPU resource request for each Redis Standalone replica node
variable "redis_standalone_replica_request_cpu" {
  type        = string
  description = "CPU resource request for each Redis Standalone replica node"
  nullable    = true
  default     = null
}

// Memory resource request for each Redis Standalone replica node
variable "redis_standalone_replica_request_memory" {
  type        = string
  description = "Memory resource request for each Redis Standalone replica node"
  nullable    = true
  default     = null
}

// CPU resource limit for each Redis Standalone replica node
variable "redis_standalone_replica_limit_cpu" {
  type        = string
  description = "CPU resource limit for each Redis Standalone replica node"
  nullable    = true
  default     = null
}

// Memory resource limit for each Redis Standalone replica node
variable "redis_standalone_replica_limit_memory" {
  type        = string
  description = "Memory resource limit for each Redis Standalone replica node"
  nullable    = true
  default     = null
}

// =========================
// Redis Standalone persistence variables
// =========================
// Defines persistent storage size for Redis data to ensure
// durability across pod restarts.

// Persistent volume size for Redis Standalone node
variable "redis_standalone_master_persistence_size" {
  type        = string
  description = "Persistent volume size for each Redis Standalone node"
  default     = "4Gi"
}

// Persistent volume size for each Redis Standalone replica node
variable "redis_standalone_replica_persistence_size" {
  type        = string
  description = "Persistent volume size for each Redis Standalone replica node"
  default     = "4Gi"
}

