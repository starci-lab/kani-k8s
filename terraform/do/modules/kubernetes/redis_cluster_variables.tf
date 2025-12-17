# =========================
# Authentication
# =========================
variable "redis_password" {
  type        = string
  description = "Password for Redis Cluster"
  sensitive   = true
}

# =========================
# Nodes
# =========================
variable "redis_nodes" {
  type        = number
  description = "Number of nodes for Redis Cluster"
  default     = 6
}

variable "redis_replicas" {
  type        = number
  description = "Number of replicas for Redis Cluster"
  default     = 1
}

variable "redis_request_cpu" {
  type        = string
  description = "Requested CPU for Redis Cluster"
  default     = "192m"
}

variable "redis_request_memory" {
  type        = string
  description = "Requested memory for Redis Cluster"
  default     = "384Mi"
}

variable "redis_limit_cpu" {
  type        = string
  description = "CPU limit for Redis Cluster"
  default     = "384m"
}

variable "redis_limit_memory" {
  type        = string
  description = "Memory limit for Redis Cluster"
  default     = "768Mi"
}

variable "redis_persistence_size" {
  type        = string
  description = "Persistent volume size for Redis Cluster"
  default     = "2Gi"
}