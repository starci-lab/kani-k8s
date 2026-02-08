// =========================
// Consul replica count
// =========================
// Controls replica count for HashiCorp Consul server.

// Number of HashiCorp Consul server replicas
variable "consul_replica_count" {
  type        = number
  description = "Number of HashiCorp Consul server replicas"
  default     = 1
}

// =========================
// Consul persistence
// =========================
// Controls persistent volume size for Consul data.

// Persistent volume size for Consul data
variable "consul_persistence_size" {
  type        = string
  description = "Persistent volume size for Consul data"
  default     = "2Gi"
}

// =========================
// Consul gossip key (optional)
// =========================
// Base64-encoded gossip key for cluster encryption; leave empty to disable.

// Base64-encoded gossip key for Consul cluster encryption (optional)
variable "consul_gossip_key" {
  type        = string
  description = "Base64-encoded gossip key for Consul cluster encryption (optional)"
  default     = ""
  sensitive   = true
}

// =========================
// Consul container resources
// =========================
// Controls resource allocation for Consul server.

// CPU resource request for Consul server
variable "consul_request_cpu" {
  type        = string
  description = "CPU resource request for Consul server"
  nullable    = true
  default     = null
}

// Memory resource request for Consul server
variable "consul_request_memory" {
  type        = string
  description = "Memory resource request for Consul server"
  nullable    = true
  default     = null
}

// CPU resource limit for Consul server
variable "consul_limit_cpu" {
  type        = string
  description = "CPU resource limit for Consul server"
  nullable    = true
  default     = null
}

// Memory resource limit for Consul server
variable "consul_limit_memory" {
  type        = string
  description = "Memory resource limit for Consul server"
  nullable    = true
  default     = null
}

// =========================
// Volume permissions init container
// =========================
// Controls resource allocation for Consul volume permissions init container.

// CPU resource request for Consul volume permissions init container
variable "consul_volume_permissions_request_cpu" {
  type        = string
  description = "CPU resource request for Consul volume permissions init container"
  nullable    = true
  default     = null
}

// Memory resource request for Consul volume permissions init container
variable "consul_volume_permissions_request_memory" {
  type        = string
  description = "Memory resource request for Consul volume permissions init container"
  nullable    = true
  default     = null
}

// CPU resource limit for Consul volume permissions init container
variable "consul_volume_permissions_limit_cpu" {
  type        = string
  description = "CPU resource limit for Consul volume permissions init container"
  nullable    = true
  default     = null
}

// Memory resource limit for Consul volume permissions init container
variable "consul_volume_permissions_limit_memory" {
  type        = string
  description = "Memory resource limit for Consul volume permissions init container"
  nullable    = true
  default     = null
}

// =========================
// Consul exporter resources
// =========================
// Controls resource allocation for Consul exporter.

// CPU resource request for Consul exporter
variable "consul_exporter_request_cpu" {
  type        = string
  description = "CPU resource request for Consul exporter"
  nullable    = true
  default     = null
}

// Memory resource request for Consul exporter
variable "consul_exporter_request_memory" {
  type        = string
  description = "Memory resource request for Consul exporter"
  nullable    = true
  default     = null
}

// CPU resource limit for Consul exporter
variable "consul_exporter_limit_cpu" {
  type        = string
  description = "CPU resource limit for Consul exporter"
  nullable    = true
  default     = null
}

// Memory resource limit for Consul exporter
variable "consul_exporter_limit_memory" {
  type        = string
  description = "Memory resource limit for Consul exporter"
  nullable    = true
  default     = null
}

// =========================
// Consul Basic Auth variables
// =========================
// Controls basic authentication for Consul ingress.

// HTPASSWD for Consul basic authentication
variable "consul_htpasswd" {
  type        = string
  description = "HTPASSWD for Consul basic authentication"
  sensitive   = true
}