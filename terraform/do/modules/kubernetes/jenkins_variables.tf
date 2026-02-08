// =========================
// Jenkins authentication
// =========================
// Controls authentication for Jenkins admin user.

variable "jenkins_user" {
  type        = string
  description = "Username for Jenkins admin user"
  default     = "admin"
}

variable "jenkins_password" {
  type        = string
  description = "Password for Jenkins admin user"
  sensitive   = true
}

variable "jenkins_replica_count" {
  type        = number
  description = "Number of Jenkins controller replicas"
  default     = 0
}

variable "jenkins_persistence_size" {
  type        = string
  description = "Persistent volume size for Jenkins home data"
  default     = "2Gi"
}

// =========================
// Jenkins resource variables
// =========================
// Controls resource allocation for Jenkins server.

variable "jenkins_request_cpu" {
  type        = string
  description = "CPU resource request for Jenkins server"
  nullable    = true
  default     = null
}

variable "jenkins_request_memory" {
  type        = string
  description = "Memory resource request for Jenkins server"
  nullable    = true
  default     = null
}

variable "jenkins_limit_cpu" {
  type        = string
  description = "CPU resource limit for Jenkins server"
  nullable    = true
  default     = null
}

variable "jenkins_limit_memory" {
  type        = string
  description = "Memory resource limit for Jenkins server"
  nullable    = true
  default     = null
}

// =========================
// Volume permissions init container resource variables
// =========================
// Controls resource allocation for the volume permissions init container.

variable "jenkins_volume_permissions_request_cpu" {
  type        = string
  description = "CPU resource request for Jenkins volume permissions init container"
  nullable    = true
  default     = null
}

variable "jenkins_volume_permissions_request_memory" {
  type        = string
  description = "Memory resource request for Jenkins volume permissions init container"
  nullable    = true
  default     = null
}

variable "jenkins_volume_permissions_limit_cpu" {
  type        = string
  description = "CPU resource limit for Jenkins volume permissions init container"
  nullable    = true
  default     = null
}

variable "jenkins_volume_permissions_limit_memory" {
  type        = string
  description = "Memory resource limit for Jenkins volume permissions init container"
  nullable    = true
  default     = null
}

// =========================
// Jenkins agent resource variables
// =========================
// Controls resource allocation for Jenkins Kubernetes agents.

variable "jenkins_agent_request_cpu" {
  type        = string
  description = "CPU resource request for Jenkins Kubernetes agents"
  nullable    = true
  default     = null
}

variable "jenkins_agent_request_memory" {
  type        = string
  description = "Memory resource request for Jenkins Kubernetes agents"
  nullable    = true
  default     = null
}

variable "jenkins_agent_limit_cpu" {
  type        = string
  description = "CPU resource limit for Jenkins Kubernetes agents"
  nullable    = true
  default     = null
}

variable "jenkins_agent_limit_memory" {
  type        = string
  description = "Memory resource limit for Jenkins Kubernetes agents"
  nullable    = true
  default     = null
}

// =========================
// Jenkins agent container cap
// =========================
// Controls the maximum number of agent containers that can run concurrently.

variable "jenkins_agent_container_cap" {
  type        = number
  description = "Maximum number of Jenkins agent containers to run concurrently"
  default     = 10
}

// =========================
// Jenkins resource presets
// =========================
// Defines preset resource configurations that can be referenced
// via the resources_config variable.

locals {
  jenkins_presets = {
    jenkins            = "96"
    volume_permissions = "16"
    agent              = "32"
  }
}

// =========================
// Jenkins resource configuration
// =========================
// Resolves resource requests and limits using either explicit
// variables or fallback to preset configurations from resources_config.

locals {
  jenkins = {
    jenkins = {
      request_cpu = coalesce(
        var.jenkins_request_cpu,
        try(var.resources_config[local.jenkins_presets.jenkins].requests.cpu, "500m")
      )
      request_memory = coalesce(
        var.jenkins_request_memory,
        try(var.resources_config[local.jenkins_presets.jenkins].requests.memory, "512Mi")
      )
      limit_cpu = coalesce(
        var.jenkins_limit_cpu,
        try(var.resources_config[local.jenkins_presets.jenkins].limits.cpu, "2000m")
      )
      limit_memory = coalesce(
        var.jenkins_limit_memory,
        try(var.resources_config[local.jenkins_presets.jenkins].limits.memory, "2048Mi")
      )
    }
    volume_permissions = {
      request_cpu = coalesce(
        var.jenkins_volume_permissions_request_cpu,
        try(var.resources_config[local.jenkins_presets.volume_permissions].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.jenkins_volume_permissions_request_memory,
        try(var.resources_config[local.jenkins_presets.volume_permissions].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.jenkins_volume_permissions_limit_cpu,
        try(var.resources_config[local.jenkins_presets.volume_permissions].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.jenkins_volume_permissions_limit_memory,
        try(var.resources_config[local.jenkins_presets.volume_permissions].limits.memory, "256Mi")
      )
    }
    agent = {
      request_cpu = coalesce(
        var.jenkins_agent_request_cpu,
        try(var.resources_config[local.jenkins_presets.agent].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.jenkins_agent_request_memory,
        try(var.resources_config[local.jenkins_presets.agent].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.jenkins_agent_limit_cpu,
        try(var.resources_config[local.jenkins_presets.agent].limits.cpu, "500m")
      )
      limit_memory = coalesce(
        var.jenkins_agent_limit_memory,
        try(var.resources_config[local.jenkins_presets.agent].limits.memory, "512Mi")
      )
    }
  }
}

