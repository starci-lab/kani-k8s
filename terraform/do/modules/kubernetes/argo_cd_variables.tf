// =========================
// Replica Counts
// =========================
// Argo CD is a declarative GitOps continuous delivery tool for Kubernetes.
// This section configures replica counts for all Argo CD components.

// Number of replicas for the Argo CD application controller pod
variable "argo_cd_controller_replica_count" {
  type        = number
  description = "Number of replicas for the Argo CD application controller"
  default     = 1
}

// Number of replicas for the Argo CD ApplicationSet controller pod
variable "argo_cd_application_set_replica_count" {
  type        = number
  description = "Number of replicas for the Argo CD ApplicationSet controller"
  default     = 1
}

// Number of replicas for the Argo CD server pod (API/UI)
variable "argo_cd_server_replica_count" {
  type        = number
  description = "Number of replicas for the Argo CD server"
  default     = 1
}

// Number of replicas for the Argo CD repo server pod
variable "argo_cd_repo_server_replica_count" {
  type        = number
  description = "Number of replicas for the Argo CD repo server"
  default     = 1
}

// =========================
// Controller Resources
// =========================
// The application controller is responsible for reconciling Application resources
// and monitoring the cluster state. This section configures CPU and memory requests and limits.

// CPU resource request for the Argo CD application controller (e.g., "16m", "32m")
variable "argo_cd_controller_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD application controller"
  nullable    = true
  default     = null
}

// Memory resource request for the Argo CD application controller (e.g., "32Mi", "64Mi")
variable "argo_cd_controller_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD application controller"
  nullable    = true
  default     = null
}

// CPU resource limit for the Argo CD application controller (typically 4x the request)
variable "argo_cd_controller_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD application controller (4x request)"
  nullable    = true
  default     = null
}

// Memory resource limit for the Argo CD application controller (typically 4x the request)
variable "argo_cd_controller_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD application controller (4x request)"
  nullable    = true
  default     = null
}

// =========================
// ApplicationSet Resources
// =========================
// The ApplicationSet controller dynamically generates Argo CD Applications from templates.
// This section configures CPU and memory requests and limits for the ApplicationSet controller.

// CPU resource request for the Argo CD ApplicationSet controller (e.g., "16m", "32m")
variable "argo_cd_application_set_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD ApplicationSet controller"
  nullable    = true
  default     = null
}

// Memory resource request for the Argo CD ApplicationSet controller (e.g., "32Mi", "64Mi")
variable "argo_cd_application_set_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD ApplicationSet controller"
  nullable    = true
  default     = null
}

// CPU resource limit for the Argo CD ApplicationSet controller (typically 4x the request)
variable "argo_cd_application_set_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD ApplicationSet controller (4x request)"
  nullable    = true
  default     = null
}

// Memory resource limit for the Argo CD ApplicationSet controller (typically 4x the request)
variable "argo_cd_application_set_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD ApplicationSet controller (4x request)"
  nullable    = true
  default     = null
}

// =========================
// Notifications Resources
// =========================
// The Notifications controller handles application event notifications (e.g., Slack, email).
// This section configures CPU and memory requests and limits for the Notifications controller.

// CPU resource request for the Argo CD Notifications controller (e.g., "16m", "32m")
variable "argo_cd_notifications_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD Notifications controller"
  nullable    = true
  default     = null
}

// Memory resource request for the Argo CD Notifications controller (e.g., "32Mi", "64Mi")
variable "argo_cd_notifications_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD Notifications controller"
  nullable    = true
  default     = null
}

// CPU resource limit for the Argo CD Notifications controller (typically 4x the request)
variable "argo_cd_notifications_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD Notifications controller (4x request)"
  nullable    = true
  default     = null
}

// Memory resource limit for the Argo CD Notifications controller (typically 4x the request)
variable "argo_cd_notifications_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD Notifications controller (4x request)"
  nullable    = true
  default     = null
}

// =========================
// Server Resources
// =========================
// The Argo CD server provides the API and web UI for managing applications.
// This section configures CPU and memory requests and limits for the server component.

// CPU resource request for the Argo CD server (e.g., "32m", "100m")
variable "argo_cd_server_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD server"
  nullable    = true
  default     = null
}

// Memory resource request for the Argo CD server (e.g., "64Mi", "128Mi")
variable "argo_cd_server_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD server"
  nullable    = true
  default     = null
}

// CPU resource limit for the Argo CD server (typically 4x the request)
variable "argo_cd_server_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD server (4x request)"
  nullable    = true
  default     = null
}

// Memory resource limit for the Argo CD server (typically 4x the request)
variable "argo_cd_server_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD server (4x request)"
  nullable    = true
  default     = null
}

// =========================
// Repo Server Resources
// =========================
// The repo-server component is responsible for fetching and rendering manifests from Git repositories.
// This section configures CPU and memory requests and limits for the repo-server component.

// CPU resource request for the Argo CD repo-server (e.g., "16m", "32m")
variable "argo_cd_repo_server_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD repo-server"
  nullable    = true
  default     = null
}

// Memory resource request for the Argo CD repo-server (e.g., "32Mi", "64Mi")
variable "argo_cd_repo_server_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD repo-server"
  nullable    = true
  default     = null
}

// CPU resource limit for the Argo CD repo-server (typically 4x the request)
variable "argo_cd_repo_server_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD repo-server (4x request)"
  nullable    = true
  default     = null
}

// Memory resource limit for the Argo CD repo-server (typically 4x the request)
variable "argo_cd_repo_server_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD repo-server (4x request)"
  nullable    = true
  default     = null
}

// =========================
// Authentication
// =========================
// Argo CD admin credentials and Redis authentication.
// NOTE: Argo CD username is always "admin" (cannot be changed).

// BCrypt-hashed admin password for Argo CD (username is always "admin")
variable "argo_cd_admin_password" {
  type        = string
  description = "BCrypt-hashed admin password for Argo CD (username is always 'admin')"
  sensitive   = true
}

// Authentication password for the Redis instance used by Argo CD
variable "argo_cd_redis_password" {
  type        = string
  description = "Authentication password for the Redis instance used by Argo CD"
  sensitive   = true
}

// =========================
// Redis Configuration
// =========================
// Redis is used for Argo CD caching, session storage, and internal state.
// This section configures resource allocation and persistence for Redis.

// CPU resource request for the Argo CD Redis (e.g., "16m", "32m")
variable "argo_cd_redis_request_cpu" {
  type        = string
  description = "CPU resource request for the Argo CD Redis"
  nullable    = true
  default     = null
}

// Memory resource request for the Argo CD Redis (e.g., "32Mi", "64Mi")
variable "argo_cd_redis_request_memory" {
  type        = string
  description = "Memory resource request for the Argo CD Redis"
  nullable    = true
  default     = null
}

// CPU resource limit for the Argo CD Redis (typically 4x the request)
variable "argo_cd_redis_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Argo CD Redis"
  nullable    = true
  default     = null
}

// Memory resource limit for the Argo CD Redis (typically 4x the request)
variable "argo_cd_redis_limit_memory" {
  type        = string
  description = "Memory resource limit for the Argo CD Redis"
  nullable    = true
  default     = null
}

// Number of Redis replica pods (0 = master only, no replication)
variable "argo_cd_redis_replica_count" {
  type        = number
  description = "Number of Redis replica pods (0 = master only)"
  default     = 0
}

// Persistent volume size for Redis master data directory
variable "argo_cd_redis_master_persistence_size" {
  type        = string
  description = "Persistent volume size for Redis master data"
  default     = "2Gi"
}

// Persistent volume size for Redis replica data directory
variable "argo_cd_redis_replica_persistence_size" {
  type        = string
  description = "Persistent volume size for Redis replica data"
  default     = "2Gi"
}

// =========================
// Computed resource values
// =========================
// Resource requests and limits for Argo CD components.
// Maps component subcomponents to resource size keys (16, 32, 64, etc.) for preset lookup.
// Uses coalesce to prefer component-specific vars, fallback to preset, then hardcoded default.
locals {
  argocd = {
    presets = {
      server         = "32"
      repo_server    = "16"
      notifications  = "16"
      applicationSet = "16"
      controller     = "16"
      redis          = "16"
    }
    server = {
      request_cpu = coalesce(
        var.argo_cd_server_request_cpu,
        try(var.resources_config[local.argocd.presets.server].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.argo_cd_server_request_memory,
        try(var.resources_config[local.argocd.presets.server].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.argo_cd_server_limit_cpu,
        try(var.resources_config[local.argocd.presets.server].limits.cpu, "256m")
      )
      limit_memory = coalesce(
        var.argo_cd_server_limit_memory,
        try(var.resources_config[local.argocd.presets.server].limits.memory, "512Mi")
      )
    }

    repo_server = {
      request_cpu = coalesce(
        var.argo_cd_repo_server_request_cpu,
        try(var.resources_config[local.argocd.presets.repo_server].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.argo_cd_repo_server_request_memory,
        try(var.resources_config[local.argocd.presets.repo_server].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.argo_cd_repo_server_limit_cpu,
        try(var.resources_config[local.argocd.presets.repo_server].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.argo_cd_repo_server_limit_memory,
        try(var.resources_config[local.argocd.presets.repo_server].limits.memory, "256Mi")
      )
    }

    notifications = {
      request_cpu = coalesce(
        var.argo_cd_notifications_request_cpu,
        try(var.resources_config[local.argocd.presets.notifications].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.argo_cd_notifications_request_memory,
        try(var.resources_config[local.argocd.presets.notifications].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.argo_cd_notifications_limit_cpu,
        try(var.resources_config[local.argocd.presets.notifications].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.argo_cd_notifications_limit_memory,
        try(var.resources_config[local.argocd.presets.notifications].limits.memory, "256Mi")
      )
    }

    application_set = {
      request_cpu = coalesce(
        var.argo_cd_application_set_request_cpu,
        try(var.resources_config[local.argocd.presets.applicationSet].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.argo_cd_application_set_request_memory,
        try(var.resources_config[local.argocd.presets.applicationSet].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.argo_cd_application_set_limit_cpu,
        try(var.resources_config[local.argocd.presets.applicationSet].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.argo_cd_application_set_limit_memory,
        try(var.resources_config[local.argocd.presets.applicationSet].limits.memory, "256Mi")
      )
    }

    controller = {
      request_cpu = coalesce(
        var.argo_cd_controller_request_cpu,
        try(var.resources_config[local.argocd.presets.controller].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.argo_cd_controller_request_memory,
        try(var.resources_config[local.argocd.presets.controller].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.argo_cd_controller_limit_cpu,
        try(var.resources_config[local.argocd.presets.controller].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.argo_cd_controller_limit_memory,
        try(var.resources_config[local.argocd.presets.controller].limits.memory, "256Mi")
      )
    }

    redis = {
      request_cpu = coalesce(
        var.argo_cd_redis_request_cpu,
        try(var.resources_config[local.argocd.presets.redis].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.argo_cd_redis_request_memory,
        try(var.resources_config[local.argocd.presets.redis].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.argo_cd_redis_limit_cpu,
        try(var.resources_config[local.argocd.presets.redis].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.argo_cd_redis_limit_memory,
        try(var.resources_config[local.argocd.presets.redis].limits.memory, "256Mi")
      )
    }
  }
}

// =========================
// Git Repository Configuration
// =========================
// Git repository used by Argo CD as the source of truth for Kubernetes manifests.

// SSH URL of the Git repository managed by Argo CD
variable "argo_cd_git_repo_url" {
  type        = string
  description = "SSH URL of the Git repository managed by Argo CD"
  default     = "git@github.com:starci-lab/kani.git"
}

// Git username (used mainly for identification/logging; SSH authentication does not require this value)
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
// Helm Repository Configuration
// =========================
// Helm repository URL for Kani Kubernetes charts.

// URL of the Kani Kubernetes Helm repository
variable "argo_cd_helm_repo_url" {
  type        = string
  description = "URL of the Kani Kubernetes Helm repository"
  default     = "http://k8s.kanibot.xyz/charts"
}
