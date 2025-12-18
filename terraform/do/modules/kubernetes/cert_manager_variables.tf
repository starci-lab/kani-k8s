// =========================
// Core Variables
// =========================
// Controls the cert-manager core component responsible for
// managing certificate lifecycle and ACME workflows.

variable "cert_manager_install_crds" {
  type        = bool
  description = "Install cert-manager CRDs"
  default     = true
}

variable "cert_manager_cert_manager_request_cpu" {
  type        = string
  description = "CPU resource request for the cert-manager core component"
  default     = "32m"
}

variable "cert_manager_cert_manager_request_memory" {
  type        = string
  description = "Memory resource request for the cert-manager core component"
  default     = "128Mi"
}

variable "cert_manager_cert_manager_limit_cpu" {
  type        = string
  description = "CPU resource limit for the cert-manager core component (4x request)"
  default     = "256m"
}

variable "cert_manager_cert_manager_limit_memory" {
  type        = string
  description = "Memory resource limit for the cert-manager core component (4x request)"
  default     = "512Mi"
}

// =========================
// Webhook Variables
// =========================
// Controls resource allocation for the webhook component,
// which validates and mutates cert-manager resources.

variable "cert_manager_webhook_request_cpu" {
  type        = string
  description = "CPU resource request for the cert-manager webhook"
  default     = "64m"
}

variable "cert_manager_webhook_request_memory" {
  type        = string
  description = "Memory resource request for the cert-manager webhook"
  default     = "128Mi"
}

variable "cert_manager_webhook_limit_cpu" {
  type        = string
  description = "CPU resource limit for the cert-manager webhook (4x request)"
  default     = "256m"
}

variable "cert_manager_webhook_limit_memory" {
  type        = string
  description = "Memory resource limit for the cert-manager webhook (4x request)"
  default     = "512Mi"
}

// =========================
// CA Injector Variables
// =========================
// Controls the CA injector component responsible for
// injecting CA bundles into Kubernetes resources.

variable "cert_manager_cainjector_request_cpu" {
  type        = string
  description = "CPU resource request for the cert-manager CA injector"
  default     = "64m"
}

variable "cert_manager_cainjector_request_memory" {
  type        = string
  description = "Memory resource request for the cert-manager CA injector"
  default     = "128Mi"
}

variable "cert_manager_cainjector_limit_cpu" {
  type        = string
  description = "CPU resource limit for the cert-manager CA injector (4x request)"
  default     = "256m"
}

variable "cert_manager_cainjector_limit_memory" {
  type        = string
  description = "Memory resource limit for the cert-manager CA injector (4x request)"
  default     = "512Mi"
}

// =========================
// Controller Variables
// =========================
// Controls the controller responsible for reconciling
// Certificate, Issuer, and ClusterIssuer resources.

variable "cert_manager_controller_request_cpu" {
  type        = string
  description = "CPU resource request for the cert-manager controller"
  default     = "64m"
}

variable "cert_manager_controller_request_memory" {
  type        = string
  description = "Memory resource request for the cert-manager controller"
  default     = "128Mi"
}

variable "cert_manager_controller_limit_cpu" {
  type        = string
  description = "CPU resource limit for the cert-manager controller (4x request)"
  default     = "256m"
}

variable "cert_manager_controller_limit_memory" {
  type        = string
  description = "Memory resource limit for the cert-manager controller (4x request)"
  default     = "512Mi"
}

// =========================
// ClusterIssuer Configuration
// =========================
// Used for ACME-based certificate issuance (e.g. Let's Encrypt).

variable "cert_manager_cluster_issuer_name" {
  type        = string
  description = "Name of the cert-manager ClusterIssuer used for issuing TLS certificates"
  default     = "letsencrypt-prod"
}

variable "cert_manager_email" {
  type        = string
  description = "Email address used for ACME registration with the certificate authority"
  default     = "cuongnvtse160875@gmail.com"
}