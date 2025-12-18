// =========================
// MongoDB authentication variables
// =========================
// Defines root (admin) credentials used to initialize
// and manage the MongoDB sharded cluster.

variable "mongodb_root_username" {
  type        = string
  description = "Root (admin) username for MongoDB with full cluster privileges"
  default     = "root"
}

variable "mongodb_root_password" {
  type        = string
  description = "Root (admin) password for MongoDB; must be provided securely"
  sensitive   = true
}

variable "mongodb_replica_set_key" {
  type        = string
  description = "Replica set key for MongoDB"
  default     = "OP6XsccLjf3751U4pngAcoutAoFqIEzk"
}

// =========================
// MongoDB sharding configuration
// =========================
// Controls the number of shards in the MongoDB sharded cluster.

variable "mongodb_shards" {
  type        = number
  description = "Number of shards in the MongoDB sharded cluster"
  default     = 1
}

// =========================
// MongoDB Config Server variables
// =========================
// Config Servers store cluster metadata and are critical
// for sharded cluster coordination.

variable "mongodb_configsvr_replica_count" {
  type        = number
  description = "Number of replicas for the MongoDB Config Server replica set"
  default     = 1
}

variable "mongodb_configsvr_persistence_size" {
  type        = string
  description = "Persistent volume size for MongoDB Config Server data"
  default     = "2Gi"
}

variable "mongodb_configsvr_request_cpu" {
  type        = string
  description = "CPU resource request for MongoDB Config Server"
  default     = "96m"
}

variable "mongodb_configsvr_request_memory" {
  type        = string
  description = "Memory resource request for MongoDB Config Server"
  default     = "192Mi"
}

variable "mongodb_configsvr_limit_cpu" {
  type        = string
  description = "CPU resource limit for MongoDB Config Server"
  default     = "256m"
}

variable "mongodb_configsvr_limit_memory" {
  type        = string
  description = "Memory resource limit for MongoDB Config Server"
  default     = "512Mi"
}

// =========================
// MongoDB Shard Server variables
// =========================
// Shard Servers store the actual application data
// and are the primary consumers of CPU, memory, and storage.

variable "mongodb_shardsvr_replica_count" {
  type        = number
  description = "Number of replicas per MongoDB shard"
  default     = 1
}

variable "mongodb_shardsvr_request_cpu" {
  type        = string
  description = "CPU resource request for MongoDB Shard Server"
  default     = "192m"
}

variable "mongodb_shardsvr_request_memory" {
  type        = string
  description = "Memory resource request for MongoDB Shard Server"
  default     = "384Mi"
}

variable "mongodb_shardsvr_limit_cpu" {
  type        = string
  description = "CPU resource limit for MongoDB Shard Server (4x request)"
  default     = "768m"
}

variable "mongodb_shardsvr_limit_memory" {
  type        = string
  description = "Memory resource limit for MongoDB Shard Server (4x request)"
  default     = "1536Mi"
}

variable "mongodb_shardsvr_persistence_size" {
  type        = string
  description = "Persistent volume size for MongoDB Shard Server data"
  default     = "8Gi"
}

// =========================
// MongoDB Mongos router variables
// =========================
// Mongos acts as the query router, directing client
// requests to the appropriate shard(s).

variable "mongodb_mongos_replica_count" {
  type        = number
  description = "Number of MongoDB mongos router replicas"
  default     = 1
}

variable "mongodb_request_cpu" {
  type        = string
  description = "CPU resource request for MongoDB mongos router"
  default     = "96m"
}

variable "mongodb_request_memory" {
  type        = string
  description = "Memory resource request for MongoDB mongos router"
  default     = "192Mi"
}

variable "mongodb_limit_cpu" {
  type        = string
  description = "CPU resource limit for MongoDB mongos router (4x request)"
  default     = "384m"
}

variable "mongodb_limit_memory" {
  type        = string
  description = "Memory resource limit for MongoDB mongos router (4x request)"
  default     = "768Mi"
}