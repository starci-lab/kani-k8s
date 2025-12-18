// =========================
// Argo CD controller variables
// =========================
// Controls the Argo CD application controller responsible for
// reconciling desired and live application states.

variable "argo_cd_controller_replica_count" {
  type        = number
  description = "Number of replicas for the Argo CD application controller"
  default     = 1
}

variable "argo_cd_controller_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD application controller"
  default     = "64m"
}

variable "argo_cd_controller_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD application controller"
  default     = "128Mi"
}

variable "argo_cd_controller_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD application controller (4x request)"
  default     = "256m"
}

variable "argo_cd_controller_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD application controller (4x request)"
  default     = "512Mi"
}

// =========================
// Argo CD ApplicationSet variables
// =========================
// Controls resource allocation for the ApplicationSet controller,
// which dynamically generates Argo CD Applications.

variable "argo_cd_application_set_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD ApplicationSet controller"
  default     = "32m"
}

variable "argo_cd_application_set_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD ApplicationSet controller"
  default     = "64Mi"
}

variable "argo_cd_application_set_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD ApplicationSet controller (4x request)"
  default     = "128m"
}

variable "argo_cd_application_set_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD ApplicationSet controller (4x request)"
  default     = "256Mi"
}

// =========================
// Argo CD Notifications variables
// =========================
// Controls resource allocation for the Notifications controller,
// which handles application event notifications.

variable "argo_cd_notifications_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD Notifications controller"
  default     = "32m"
}

variable "argo_cd_notifications_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD Notifications controller"
  default     = "64Mi"
}

variable "argo_cd_notifications_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD Notifications controller (4x request)"
  default     = "128m"
}

variable "argo_cd_notifications_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD Notifications controller (4x request)"
  default     = "256Mi"
}

// =========================
// Argo CD server variables
// =========================
// Controls the Argo CD API server and web UI.

variable "argo_cd_server_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD server"
  default     = "32m"
}

variable "argo_cd_server_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD server"
  default     = "64Mi"
}

variable "argo_cd_server_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD server (4x request)"
  default     = "128m"
}

variable "argo_cd_server_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD server (4x request)"
  default     = "256Mi"
}

// =========================
// Argo CD repo-server variables
// =========================
// Controls the repo-server component responsible for
// fetching and rendering manifests from Git repositories.

variable "argo_cd_repo_server_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD repo-server"
  default     = "32m"
}

variable "argo_cd_repo_server_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD repo-server"
  default     = "64Mi"
}

variable "argo_cd_repo_server_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD repo-server (4x request)"
  default     = "128m"
}

variable "argo_cd_repo_server_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD repo-server (4x request)"
  default     = "256Mi"
}

// =========================
// Argo CD admin credentials
// =========================
// NOTE: Argo CD username is always "admin" (cannot be changed).
// Password should be provided as a bcrypt hash.

variable "argo_cd_admin_password" {
  type        = string
  description = "BCrypt-hashed admin password for Argo CD (username is always 'admin')"
  sensitive   = true
}

// =========================
// Argo CD Redis configuration
// =========================
// Used for Argo CD caching, session storage, and internal state.

variable "argo_cd_redis_host" {
  type        = string
  description = "Hostname or service address of the Redis instance used by Argo CD"
  default     = "redis-cluster.redis-cluster.svc.cluster.local"
}

variable "argo_cd_redis_password" {
  type        = string
  description = "Authentication password for the Redis instance used by Argo CD"
  sensitive   = true
}