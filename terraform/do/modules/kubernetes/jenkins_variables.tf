// =========================
// Jenkins authentication
// =========================
// Controls authentication for Jenkins admin user.

// Username for Jenkins admin user
variable "jenkins_user" {
  type        = string
  description = "Username for Jenkins admin user"
  default     = "admin"
}

// Password for Jenkins admin user
variable "jenkins_password" {
  type        = string
  description = "Password for Jenkins admin user"
  sensitive   = true
}

// =========================
// Jenkins deployment configuration
// =========================
// Controls replica count and persistence for Jenkins controller.

// Number of replicas for Jenkins controller
variable "jenkins_replica_count" {
  type        = number
  description = "Number of Jenkins controller replicas"
  default     = 0
}

// Persistent volume size for Jenkins home data
variable "jenkins_persistence_size" {
  type        = string
  description = "Persistent volume size for Jenkins home data"
  default     = "2Gi"
}

// =========================
// Jenkins server resource variables
// =========================
// Controls resource allocation for Jenkins server.

// CPU resource request for Jenkins server
variable "jenkins_request_cpu" {
  type        = string
  description = "CPU resource request for Jenkins server"
  nullable    = true
  default     = null
}

// Memory resource request for Jenkins server
variable "jenkins_request_memory" {
  type        = string
  description = "Memory resource request for Jenkins server"
  nullable    = true
  default     = null
}

// CPU resource limit for Jenkins server
variable "jenkins_limit_cpu" {
  type        = string
  description = "CPU resource limit for Jenkins server"
  nullable    = true
  default     = null
}

// Memory resource limit for Jenkins server
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

// CPU resource request for Jenkins volume permissions init container
variable "jenkins_volume_permissions_request_cpu" {
  type        = string
  description = "CPU resource request for Jenkins volume permissions init container"
  nullable    = true
  default     = null
}

// Memory resource request for Jenkins volume permissions init container
variable "jenkins_volume_permissions_request_memory" {
  type        = string
  description = "Memory resource request for Jenkins volume permissions init container"
  nullable    = true
  default     = null
}

// CPU resource limit for Jenkins volume permissions init container
variable "jenkins_volume_permissions_limit_cpu" {
  type        = string
  description = "CPU resource limit for Jenkins volume permissions init container"
  nullable    = true
  default     = null
}

// Memory resource limit for Jenkins volume permissions init container
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

// CPU resource request for Jenkins Kubernetes agents
variable "jenkins_agent_request_cpu" {
  type        = string
  description = "CPU resource request for Jenkins Kubernetes agents"
  nullable    = true
  default     = null
}

// Memory resource request for Jenkins Kubernetes agents
variable "jenkins_agent_request_memory" {
  type        = string
  description = "Memory resource request for Jenkins Kubernetes agents"
  nullable    = true
  default     = null
}

// CPU resource limit for Jenkins Kubernetes agents
variable "jenkins_agent_limit_cpu" {
  type        = string
  description = "CPU resource limit for Jenkins Kubernetes agents"
  nullable    = true
  default     = null
}

// Memory resource limit for Jenkins Kubernetes agents
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

// Maximum number of Jenkins agent containers to run concurrently
variable "jenkins_agent_container_cap" {
  type        = number
  description = "Maximum number of Jenkins agent containers to run concurrently"
  default     = 10
}

// =========================
// Jenkins deployment rollout webhook tokens
// =========================
// Used by Jenkins pipeline jobs for Kani Interface, Coordinator, and Observer.

// Webhook token for Kani Interface deployment rollout pipeline
variable "kani_interface_deployment_rollout_webhook_token" {
  type        = string
  description = "Webhook token for Kani Interface deployment rollout pipeline"
  sensitive   = true
}

// Webhook token for Kani Coordinator deployment rollout pipeline
variable "kani_coordinator_deployment_rollout_webhook_token" {
  type        = string
  description = "Webhook token for Kani Coordinator deployment rollout pipeline"
  sensitive   = true
}

// Webhook token for Kani Observer deployment rollout pipeline
variable "kani_observer_deployment_rollout_webhook_token" {
  type        = string
  description = "Webhook token for Kani Observer deployment rollout pipeline"
  sensitive   = true
}
