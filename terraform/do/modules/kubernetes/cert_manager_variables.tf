// =========================
// Installation and Replica Counts
// =========================
// cert-manager is a Kubernetes add-on to automate the management and issuance of TLS certificates.
// This section configures CRD installation and replica counts for all cert-manager components.

// Whether to install cert-manager Custom Resource Definitions (CRDs) during Helm chart installation
variable "cert_manager_install_crds" {
  type        = bool
  description = "Install cert-manager CRDs"
  default     = true
}

// Number of replicas for the cert-manager controller pod
variable "cert_manager_controller_replica_count" {
  type        = number
  description = "Number of cert-manager controller replicas"
  default     = 1
}

// Number of replicas for the cert-manager webhook pod
variable "cert_manager_webhook_replica_count" {
  type        = number
  description = "Number of cert-manager webhook replicas"
  default     = 1
}

// Number of replicas for the cert-manager CA injector pod
variable "cert_manager_cainjector_replica_count" {
  type        = number
  description = "Number of cert-manager CA injector replicas"
  default     = 1
}

// =========================
// Core Component Resources
// =========================
// cert-manager core component is responsible for managing certificate lifecycle and ACME workflows.
// This section configures CPU and memory requests and limits for the core component.

// CPU resource request for the cert-manager core component (e.g., "32m", "100m")
variable "cert_manager_cert_manager_request_cpu" {
  type        = string
  description = "CPU resource request for the cert-manager core component"
  nullable    = true
  default     = null
}

// Memory resource request for the cert-manager core component (e.g., "128Mi", "256Mi")
variable "cert_manager_cert_manager_request_memory" {
  type        = string
  description = "Memory resource request for the cert-manager core component"
  nullable    = true
  default     = null
}

// CPU resource limit for the cert-manager core component (typically 4x the request)
variable "cert_manager_cert_manager_limit_cpu" {
  type        = string
  description = "CPU resource limit for the cert-manager core component (4x request)"
  nullable    = true
  default     = null
}

// Memory resource limit for the cert-manager core component (typically 4x the request)
variable "cert_manager_cert_manager_limit_memory" {
  type        = string
  description = "Memory resource limit for the cert-manager core component (4x request)"
  nullable    = true
  default     = null
}

// =========================
// Webhook Resources
// =========================
// The webhook component validates and mutates cert-manager resources (Certificate, Issuer, ClusterIssuer).
// This section configures CPU and memory requests and limits for the webhook component.

// CPU resource request for the cert-manager webhook component (e.g., "64m", "100m")
variable "cert_manager_webhook_request_cpu" {
  type        = string
  description = "CPU resource request for the cert-manager webhook"
  nullable    = true
  default     = null
}

// Memory resource request for the cert-manager webhook component (e.g., "128Mi", "256Mi")
variable "cert_manager_webhook_request_memory" {
  type        = string
  description = "Memory resource request for the cert-manager webhook"
  nullable    = true
  default     = null
}

// CPU resource limit for the cert-manager webhook component (typically 4x the request)
variable "cert_manager_webhook_limit_cpu" {
  type        = string
  description = "CPU resource limit for the cert-manager webhook (4x request)"
  nullable    = true
  default     = null
}

// Memory resource limit for the cert-manager webhook component (typically 4x the request)
variable "cert_manager_webhook_limit_memory" {
  type        = string
  description = "Memory resource limit for the cert-manager webhook (4x request)"
  nullable    = true
  default     = null
}

// =========================
// CA Injector Resources
// =========================
// The CA injector component is responsible for injecting CA bundles into Kubernetes resources
// (e.g., MutatingWebhookConfiguration, ValidatingWebhookConfiguration).
// This section configures CPU and memory requests and limits for the CA injector component.

// CPU resource request for the cert-manager CA injector component (e.g., "64m", "100m")
variable "cert_manager_cainjector_request_cpu" {
  type        = string
  description = "CPU resource request for the cert-manager CA injector"
  nullable    = true
  default     = null
}

// Memory resource request for the cert-manager CA injector component (e.g., "128Mi", "256Mi")
variable "cert_manager_cainjector_request_memory" {
  type        = string
  description = "Memory resource request for the cert-manager CA injector"
  nullable    = true
  default     = null
}

// CPU resource limit for the cert-manager CA injector component (typically 4x the request)
variable "cert_manager_cainjector_limit_cpu" {
  type        = string
  description = "CPU resource limit for the cert-manager CA injector (4x request)"
  nullable    = true
  default     = null
}

// Memory resource limit for the cert-manager CA injector component (typically 4x the request)
variable "cert_manager_cainjector_limit_memory" {
  type        = string
  description = "Memory resource limit for the cert-manager CA injector (4x request)"
  nullable    = true
  default     = null
}

// =========================
// Controller Resources
// =========================
// The controller is responsible for reconciling Certificate, Issuer, and ClusterIssuer resources.
// It monitors these resources and performs certificate issuance, renewal, and revocation.
// This section configures CPU and memory requests and limits for the controller component.

// CPU resource request for the cert-manager controller component (e.g., "64m", "100m")
variable "cert_manager_controller_request_cpu" {
  type        = string
  description = "CPU resource request for the cert-manager controller"
  nullable    = true
  default     = null
}

// Memory resource request for the cert-manager controller component (e.g., "128Mi", "256Mi")
variable "cert_manager_controller_request_memory" {
  type        = string
  description = "Memory resource request for the cert-manager controller"
  nullable    = true
  default     = null
}

// CPU resource limit for the cert-manager controller component (typically 4x the request)
variable "cert_manager_controller_limit_cpu" {
  type        = string
  description = "CPU resource limit for the cert-manager controller (4x request)"
  nullable    = true
  default     = null
}

// Memory resource limit for the cert-manager controller component (typically 4x the request)
variable "cert_manager_controller_limit_memory" {
  type        = string
  description = "Memory resource limit for the cert-manager controller (4x request)"
  nullable    = true
  default     = null
}

// =========================
// ClusterIssuer Configuration
// =========================
// ClusterIssuer is a cluster-scoped resource used for ACME-based certificate issuance (e.g. Let's Encrypt).
// This section configures the ClusterIssuer name and email address for ACME registration.

// Name of the cert-manager ClusterIssuer resource used for issuing TLS certificates via ACME
variable "cert_manager_cluster_issuer_name" {
  type        = string
  description = "Name of the cert-manager ClusterIssuer used for issuing TLS certificates"
  default     = "letsencrypt-prod"
}

// Email address used for ACME registration with Let's Encrypt or other certificate authority
variable "cert_manager_email" {
  type        = string
  description = "Email address used for ACME registration with the certificate authority"
  default     = "cuongnvtse160875@gmail.com"
}