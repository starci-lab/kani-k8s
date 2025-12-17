# =========================
# Authentication
# =========================
variable "mongodb_root_username" {
  type        = string
  description = "Username for MongoDB"
  default     = "root"
}

variable "mongodb_root_password" {
  type        = string
  description = "Root password for MongoDB"
  sensitive   = true
}

# =========================
# Shards
# =========================
variable "mongodb_shards" {
  type        = number
  description = "Number of shards for MongoDB"
  default     = 1
}
# =========================
# Config Server
# =========================

variable "mongodb_configsvr_replica_count" {
  type        = number
  description = "Number of replicas for MongoDB Config Server"
  default     = 1
}

variable "mongodb_configsvr_persistence_size" {
  type        = string
  description = "Persistent volume size for Config Server"
  default     = "2Gi"
}

variable "mongodb_configsvr_request_cpu" {
  type        = string
  description = "Requested CPU for Config Server"
  default     = "192m"
}

variable "mongodb_configsvr_request_memory" {
  type        = string
  description = "Requested memory for Config Server"
  default     = "384Mi"
}

variable "mongodb_configsvr_limit_cpu" {
  type        = string
  description = "CPU limit for Config Server"
  default     = "384m"
}

variable "mongodb_configsvr_limit_memory" {
  type        = string
  description = "Memory limit for Config Server"
  default     = "768Mi"
}

# =========================
# Shard Server
# =========================

variable "mongodb_shardsvr_replica_count" {
  type        = number
  description = "Number of replicas per shard"
  default     = 1
}

variable "mongodb_shardsvr_request_cpu" {
  type        = string
  description = "Requested CPU for Shard Server"
  default     = "384m"
}

variable "mongodb_shardsvr_request_memory" {
  type        = string
  description = "Requested memory for Shard Server"
  default     = "768Mi"
}

variable "mongodb_shardsvr_limit_cpu" {
  type        = string
  description = "CPU limit for Shard Server"
  default     = "768m"
}

variable "mongodb_shardsvr_limit_memory" {
  type        = string
  description = "Memory limit for Shard Server"
  default     = "1536Mi"
}

variable "mongodb_shardsvr_persistence_size" {
  type        = string
  description = "Persistent volume size for Shard Server"
  default     = "4Gi"
}

# =========================
# Mongos Router
# =========================

variable "mongodb_mongos_replica_count" {
  type        = number
  description = "Number of mongos router replicas"
  default     = 1
}

variable "mongodb_request_cpu" {
  type        = string
  description = "Requested CPU for Mongos"
  default     = "192m"
}

variable "mongodb_request_memory" {
  type        = string
  description = "Requested memory for Mongos"
  default     = "384Mi"
}

variable "mongodb_limit_cpu" {
  type        = string
  description = "CPU limit for Mongos"
  default     = "384m"
}

variable "mongodb_limit_memory" {
  type        = string
  description = "Memory limit for Mongos"
  default     = "768Mi"
}