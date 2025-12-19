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
  nullable    = true
  default     = null
}

variable "argo_cd_controller_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD application controller"
  nullable    = true
  default     = null
}

variable "argo_cd_controller_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD application controller (4x request)"
  nullable    = true
  default     = null
}

variable "argo_cd_controller_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD application controller (4x request)"
  nullable    = true
  default     = null
}

// =========================
// Argo CD ApplicationSet variables
// =========================
// Controls resource allocation for the ApplicationSet controller,
// which dynamically generates Argo CD Applications.

variable "argo_cd_application_set_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD ApplicationSet controller"
  nullable    = true
  default     = null
}

variable "argo_cd_application_set_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD ApplicationSet controller"
  nullable    = true
  default     = null
}

variable "argo_cd_application_set_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD ApplicationSet controller (4x request)"
  nullable    = true
  default     = null
}

variable "argo_cd_application_set_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD ApplicationSet controller (4x request)"
  nullable    = true
  default     = null
}

// =========================
// Argo CD Notifications variables
// =========================
// Controls resource allocation for the Notifications controller,
// which handles application event notifications.

variable "argo_cd_notifications_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD Notifications controller"
  nullable    = true
  default     = null
}

variable "argo_cd_notifications_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD Notifications controller"
  nullable    = true
  default     = null
}

variable "argo_cd_notifications_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD Notifications controller (4x request)"
  nullable    = true
  default     = null
}

variable "argo_cd_notifications_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD Notifications controller (4x request)"
  nullable    = true
  default     = null
}

// =========================
// Argo CD server variables
// =========================
// Controls the Argo CD API server and web UI.

variable "argo_cd_server_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD server"
  nullable    = true
  default     = null
}

variable "argo_cd_server_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD server"
  nullable    = true
  default     = null
}

variable "argo_cd_server_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD server (4x request)"
  nullable    = true
  default     = null
}

variable "argo_cd_server_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD server (4x request)"
  nullable    = true
  default     = null
}

// =========================
// Argo CD repo-server variables
// =========================
// Controls the repo-server component responsible for
// fetching and rendering manifests from Git repositories.

variable "argo_cd_repo_server_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD repo-server"
  nullable    = true
  default     = null
}

variable "argo_cd_repo_server_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD repo-server"
  nullable    = true
  default     = null
}

variable "argo_cd_repo_server_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD repo-server (4x request)"
  nullable    = true
  default     = null
}

variable "argo_cd_repo_server_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD repo-server (4x request)"
  nullable    = true
  default     = null
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

variable "argo_cd_redis_password" {
  type        = string
  description = "Authentication password for the Redis instance used by Argo CD"
  sensitive   = true
}

// =========================
// Argo CD Redis configuration
// =========================
// Used for Argo CD caching, session storage, and internal state.

variable "argo_cd_redis_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD Redis"
  nullable    = true
  default     = null
}

variable "argo_cd_redis_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD Redis"
  nullable    = true
  default     = null
}

variable "argo_cd_redis_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD Redis"
  nullable    = true
  default     = null
}

variable "argo_cd_redis_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD Redis"
  nullable    = true
  default     = null
}

locals {
  argocd_presets = {
    server         = "32"
    repo_server    = "16"
    notifications  = "16"
    applicationSet = "16"
    controller     = "16"
    redis          = "16"
  }
}

locals {
  argocd = {
    server = {
      request_cpu = coalesce(
        var.argo_cd_server_request_cpu,
        try(var.resources_config[local.argocd_presets.server].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.argo_cd_server_request_memory,
        try(var.resources_config[local.argocd_presets.server].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.argo_cd_server_limit_cpu,
        try(var.resources_config[local.argocd_presets.server].limits.cpu, "256m")
      )
      limit_memory = coalesce(
        var.argo_cd_server_limit_memory,
        try(var.resources_config[local.argocd_presets.server].limits.memory, "512Mi")
      )
    }

    repo_server = {
      request_cpu = coalesce(
        var.argo_cd_repo_server_request_cpu,
        try(var.resources_config[local.argocd_presets.repo_server].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.argo_cd_repo_server_request_memory,
        try(var.resources_config[local.argocd_presets.repo_server].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.argo_cd_repo_server_limit_cpu,
        try(var.resources_config[local.argocd_presets.repo_server].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.argo_cd_repo_server_limit_memory,
        try(var.resources_config[local.argocd_presets.repo_server].limits.memory, "256Mi")
      )
    }

    notifications = {
      request_cpu = coalesce(
        var.argo_cd_notifications_request_cpu,
        try(var.resources_config[local.argocd_presets.notifications].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.argo_cd_notifications_request_memory,
        try(var.resources_config[local.argocd_presets.notifications].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.argo_cd_notifications_limit_cpu,
        try(var.resources_config[local.argocd_presets.notifications].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.argo_cd_notifications_limit_memory,
        try(var.resources_config[local.argocd_presets.notifications].limits.memory, "256Mi")
      )
    }

    application_set = {
      request_cpu = coalesce(
        var.argo_cd_application_set_request_cpu,
        try(var.resources_config[local.argocd_presets.applicationSet].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.argo_cd_application_set_request_memory,
        try(var.resources_config[local.argocd_presets.applicationSet].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.argo_cd_application_set_limit_cpu,
        try(var.resources_config[local.argocd_presets.applicationSet].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.argo_cd_application_set_limit_memory,
        try(var.resources_config[local.argocd_presets.applicationSet].limits.memory, "256Mi")
      )
    }

    controller = {
      request_cpu = coalesce(
        var.argo_cd_controller_request_cpu,
        try(var.resources_config[local.argocd_presets.controller].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.argo_cd_controller_request_memory,
        try(var.resources_config[local.argocd_presets.controller].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.argo_cd_controller_limit_cpu,
        try(var.resources_config[local.argocd_presets.controller].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.argo_cd_controller_limit_memory,
        try(var.resources_config[local.argocd_presets.controller].limits.memory, "256Mi")
      )
    }

    redis = {
      request_cpu = coalesce(
        var.argo_cd_redis_request_cpu,
        try(var.resources_config[local.argocd_presets.redis].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.argo_cd_redis_request_memory,
        try(var.resources_config[local.argocd_presets.redis].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.argo_cd_redis_limit_cpu,
        try(var.resources_config[local.argocd_presets.redis].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.argo_cd_redis_limit_memory,
        try(var.resources_config[local.argocd_presets.redis].limits.memory, "256Mi")
      )
    }
  }
}

// =========================
// Argo CD Git repository configuration
// =========================

// SSH URL of the Git repository managed by Argo CD
variable "argo_cd_git_repo_url" {
  type        = string
  description = "SSH URL of the Git repository managed by Argo CD"
  default     = "git@github.com:starci-lab/kani.git"
}

// Git username (used mainly for identification/logging;
// SSH authentication does not require this value)
variable "argo_cd_git_username" {
  type        = string
  description = "Git username associated with the Argo CD Git repository"
  default     = "starci183"
}

// SSH private key used by Argo CD to authenticate to the Git repository
variable "argo_cd_git_ssh_private_key" {
  type        = string
  description = "SSH private key used by Argo CD to access the Git repository"
  sensitive   = true
}

// =========================
// Argo CD Helm repository configuration
// =========================

variable "argo_cd_helm_repo_url" {
  type        = string
  description = "URL of the Kani Kubernetes Helm repository"
  default     = "http://starci-lab.github.io/kani-k8s/charts"
}
