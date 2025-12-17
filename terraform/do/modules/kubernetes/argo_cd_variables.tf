# Controller
# =========================
variable "argo_cd_controller_replica_count" {
  type        = number
  description = "Number of controller replicas"
  default     = 1
}

variable "argo_cd_controller_request_cpu" {
  type        = string
  description = "Requested CPU for controller"
  default     = "128m"
}

variable "argo_cd_controller_request_memory" {
  type        = string
  description = "Requested memory for controller"
  default     = "256Mi"
}

variable "argo_cd_controller_limit_cpu" {
  type        = string
  description = "CPU limit for controller"
  default     = "256m"
} 

variable "argo_cd_controller_limit_memory" {
  type        = string
  description = "Memory limit for controller"
  default     = "512Mi"
}

# Application Set
# =========================
variable "argo_cd_application_set_request_cpu" {
  type        = string
  description = "Requested CPU for application set"
  default     = "64m"
}

variable "argo_cd_application_set_request_memory" {
  type        = string
  description = "Requested memory for application set"
  default     = "128Mi"
}

variable "argo_cd_application_set_limit_cpu" {
  type        = string
  description = "CPU limit for application set"
  default     = "128m"
}

variable "argo_cd_application_set_limit_memory" {
  type        = string
  description = "Memory limit for application set"
  default     = "256Mi"
}

# Notifications
# =========================
variable "argo_cd_notifications_request_cpu" {
  type        = string
  description = "Requested CPU for notifications"
  default     = "64m"
}

variable "argo_cd_notifications_request_memory" {
  type        = string
  description = "Requested memory for notifications"
  default     = "128Mi"
}

variable "argo_cd_notifications_limit_cpu" {
  type        = string
  description = "CPU limit for notifications"
  default     = "128m"
}

variable "argo_cd_notifications_limit_memory" {
  type        = string
  description = "Memory limit for notifications"
  default     = "256Mi"
}

# Server
# =========================
variable "argo_cd_server_request_cpu" {
  type        = string
  description = "Requested CPU for server"
  default     = "64m"
}

variable "argo_cd_server_request_memory" {
  type        = string
  description = "Requested memory for server"
  default     = "128Mi"
}

variable "argo_cd_server_limit_cpu" {
  type        = string
  description = "CPU limit for server"
  default     = "128m"
}

variable "argo_cd_server_limit_memory" {
  type        = string
  description = "Memory limit for server"
  default     = "256Mi"
}

# Repo Server
# =========================
variable "argo_cd_repo_server_request_cpu" {
  type        = string
  description = "Requested CPU for repo server"
  default     = "64m"
}

variable "argo_cd_repo_server_request_memory" {
  type        = string
  description = "Requested memory for repo server"
  default     = "128Mi"
} 

variable "argo_cd_repo_server_limit_cpu" {
  type        = string
  description = "CPU limit for repo server"
  default     = "128m"
}

variable "argo_cd_repo_server_limit_memory" {
  type        = string
  description = "Memory limit for repo server"
  default     = "256Mi"
}

# Admin Password
# =========================
variable "argo_cd_admin_password" {
  type        = string
  description = "Admin password for Argo CD"
  sensitive   = true
}

# Redis Host
# =========================
variable "argo_cd_redis_host" {
  type        = string
  description = "Argo CD Redis host"
  default     = "redis-cluster.redis-cluster.svc.cluster.local"
}

# Redis Password
# =========================
variable "argo_cd_redis_password" {
  type        = string
  description = "Argo CD Redis password"
  sensitive   = true
}