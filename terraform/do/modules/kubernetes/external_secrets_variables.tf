// =========================
// Replica Counts
// =========================
// External Secrets Operator is a Kubernetes operator that integrates external secret management systems.
// This section configures replica counts for all External Secrets components.

// Number of replicas for the External Secrets operator pod
variable "external_secrets_operator_replica_count" {
  type        = number
  description = "Number of External Secrets operator replicas"
  default     = 1
}

// Number of replicas for the External Secrets webhook pod
variable "external_secrets_webhook_replica_count" {
  type        = number
  description = "Number of External Secrets webhook replicas"
  default     = 1
}

// Number of replicas for the External Secrets cert controller pod
variable "external_secrets_cert_controller_replica_count" {
  type        = number
  description = "Number of External Secrets cert controller replicas"
  default     = 1
}

// =========================
// Operator Resources
// =========================
// The External Secrets operator is responsible for syncing secrets from external secret management systems.
// This section configures CPU and memory requests and limits for the operator component.

// CPU resource request for the External Secrets operator (e.g., "100m", "200m")
variable "external_secrets_request_cpu" {
  type        = string
  description = "CPU resource request for External Secrets"
  nullable    = true
  default     = null
}

// Memory resource request for the External Secrets operator (e.g., "128Mi", "256Mi")
variable "external_secrets_request_memory" {
  type        = string
  description = "Memory resource request for External Secrets"
  nullable    = true
  default     = null
}

// CPU resource limit for the External Secrets operator (typically 2x the request)
variable "external_secrets_limit_cpu" {
  type        = string
  description = "CPU resource limit for External Secrets"
  nullable    = true
  default     = null
}

// Memory resource limit for the External Secrets operator (typically 2x the request)
variable "external_secrets_limit_memory" {
  type        = string
  description = "Memory resource limit for External Secrets"
  nullable    = true
  default     = null
}

// =========================
// Webhook Resources
// =========================
// The webhook component validates and mutates ExternalSecret resources.
// This section configures CPU and memory requests and limits for the webhook component.

// CPU resource request for the External Secrets webhook (e.g., "100m", "200m")
variable "webhook_request_cpu" {
  type        = string
  description = "CPU resource request for Webhook"
  nullable    = true
  default     = null
}

// Memory resource request for the External Secrets webhook (e.g., "128Mi", "256Mi")
variable "webhook_request_memory" {
  type        = string
  description = "Memory resource request for Webhook"
  nullable    = true
  default     = null
}

// CPU resource limit for the External Secrets webhook (typically 2x the request)
variable "webhook_limit_cpu" {
  type        = string
  description = "CPU resource limit for Webhook"
  nullable    = true
  default     = null
}

// Memory resource limit for the External Secrets webhook (typically 2x the request)
variable "webhook_limit_memory" {
  type        = string
  description = "Memory resource limit for Webhook"
  nullable    = true
  default     = null
}

// =========================
// Cert Controller Resources
// =========================
// The cert controller manages TLS certificates for External Secrets components.
// This section configures CPU and memory requests and limits for the cert controller component.

// CPU resource request for the External Secrets cert controller (e.g., "100m", "200m")
variable "cert_controller_request_cpu" {
  type        = string
  description = "CPU resource request for Cert Controller"
  nullable    = true
  default     = null
}

// Memory resource request for the External Secrets cert controller (e.g., "128Mi", "256Mi")
variable "cert_controller_request_memory" {
  type        = string
  description = "Memory resource request for Cert Controller"
  nullable    = true
  default     = null
}

// CPU resource limit for the External Secrets cert controller (typically 2x the request)
variable "cert_controller_limit_cpu" {
  type        = string
  description = "CPU resource limit for Cert Controller"
  nullable    = true
  default     = null
}

// Memory resource limit for the External Secrets cert controller (typically 2x the request)
variable "cert_controller_limit_memory" {
  type        = string
  description = "Memory resource limit for Cert Controller"
  nullable    = true
  default     = null
}

// =========================
// Secret Version Configuration
// =========================
// Version numbers for GCP Secret Manager secrets to be synced into Kubernetes.

// Version number of the app secret in GCP Secret Manager
variable "app_secret_version" {
  type        = number
  description = "App secret version"
}

// Version number of the rpcs secret in GCP Secret Manager
variable "rpcs_secret_version" {
  type        = number
  description = "RPCs secret version"
}

