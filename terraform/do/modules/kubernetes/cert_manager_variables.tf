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

variable "cert_manager_controller_replica_count" {
  type        = number
  description = "Number of cert-manager controller replicas"
  default     = 1
}

variable "cert_manager_webhook_replica_count" {
  type        = number
  description = "Number of cert-manager webhook replicas"
  default     = 1
}

variable "cert_manager_cainjector_replica_count" {
  type        = number
  description = "Number of cert-manager CA injector replicas"
  default     = 1
}

variable "cert_manager_cert_manager_request_cpu" {
  type        = string
  description = "CPU resource request for the cert-manager core component"
  nullable    = true
  default     = null
}

variable "cert_manager_cert_manager_request_memory" {
  type        = string
  description = "Memory resource request for the cert-manager core component"
  nullable    = true
  default     = null
}

variable "cert_manager_cert_manager_limit_cpu" {
  type        = string
  description = "CPU resource limit for the cert-manager core component (4x request)"
  nullable    = true
  default     = null
}

variable "cert_manager_cert_manager_limit_memory" {
  type        = string
  description = "Memory resource limit for the cert-manager core component (4x request)"
  nullable    = true
  default     = null
}

// =========================
// Webhook Variables
// =========================
// Controls resource allocation for the webhook component,
// which validates and mutates cert-manager resources.

variable "cert_manager_webhook_request_cpu" {
  type        = string
  description = "CPU resource request for the cert-manager webhook"
  nullable    = true
  default     = null
}

variable "cert_manager_webhook_request_memory" {
  type        = string
  description = "Memory resource request for the cert-manager webhook"
  nullable    = true
  default     = null
}

variable "cert_manager_webhook_limit_cpu" {
  type        = string
  description = "CPU resource limit for the cert-manager webhook (4x request)"
  nullable    = true
  default     = null
}

variable "cert_manager_webhook_limit_memory" {
  type        = string
  description = "Memory resource limit for the cert-manager webhook (4x request)"
  nullable    = true
  default     = null
}

// =========================
// CA Injector Variables
// =========================
// Controls the CA injector component responsible for
// injecting CA bundles into Kubernetes resources.

variable "cert_manager_cainjector_request_cpu" {
  type        = string
  description = "CPU resource request for the cert-manager CA injector"
  nullable    = true
  default     = null
}

variable "cert_manager_cainjector_request_memory" {
  type        = string
  description = "Memory resource request for the cert-manager CA injector"
  nullable    = true
  default     = null
}

variable "cert_manager_cainjector_limit_cpu" {
  type        = string
  description = "CPU resource limit for the cert-manager CA injector (4x request)"
  nullable    = true
  default     = null
}

variable "cert_manager_cainjector_limit_memory" {
  type        = string
  description = "Memory resource limit for the cert-manager CA injector (4x request)"
  nullable    = true
  default     = null
}

// =========================
// Controller Variables
// =========================
// Controls the controller responsible for reconciling
// Certificate, Issuer, and ClusterIssuer resources.

variable "cert_manager_controller_request_cpu" {
  type        = string
  description = "CPU resource request for the cert-manager controller"
  nullable    = true
  default     = null
}

variable "cert_manager_controller_request_memory" {
  type        = string
  description = "Memory resource request for the cert-manager controller"
  nullable    = true
  default     = null
}

variable "cert_manager_controller_limit_cpu" {
  type        = string
  description = "CPU resource limit for the cert-manager controller (4x request)"
  nullable    = true
  default     = null
}

variable "cert_manager_controller_limit_memory" {
  type        = string
  description = "Memory resource limit for the cert-manager controller (4x request)"
  nullable    = true
  default     = null
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

locals {
  cert_manager_presets = {
    cert_manager = "16"
    webhook      = "16"
    cainjector   = "16"
    controller   = "16"
  }
}

locals {
  cert_manager = {
    cert_manager = {
      request_cpu = coalesce(
        var.cert_manager_cert_manager_request_cpu,
        try(var.resources_config[local.cert_manager_presets.cert_manager].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.cert_manager_cert_manager_request_memory,
        try(var.resources_config[local.cert_manager_presets.cert_manager].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.cert_manager_cert_manager_limit_cpu,
        try(var.resources_config[local.cert_manager_presets.cert_manager].limits.cpu, "256m")
      )
      limit_memory = coalesce(
        var.cert_manager_cert_manager_limit_memory,
        try(var.resources_config[local.cert_manager_presets.cert_manager].limits.memory, "512Mi")
      )
    }

    webhook = {
      request_cpu = coalesce(
        var.cert_manager_webhook_request_cpu,
        try(var.resources_config[local.cert_manager_presets.webhook].requests.cpu, "64m")
      )
      request_memory = coalesce(
        var.cert_manager_webhook_request_memory,
        try(var.resources_config[local.cert_manager_presets.webhook].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.cert_manager_webhook_limit_cpu,
        try(var.resources_config[local.cert_manager_presets.webhook].limits.cpu, "256m")
      )
      limit_memory = coalesce(
        var.cert_manager_webhook_limit_memory,
        try(var.resources_config[local.cert_manager_presets.webhook].limits.memory, "512Mi")
      )
    }

    cainjector = {
      request_cpu = coalesce(
        var.cert_manager_cainjector_request_cpu,
        try(var.resources_config[local.cert_manager_presets.cainjector].requests.cpu, "64m")
      )
      request_memory = coalesce(
        var.cert_manager_cainjector_request_memory,
        try(var.resources_config[local.cert_manager_presets.cainjector].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.cert_manager_cainjector_limit_cpu,
        try(var.resources_config[local.cert_manager_presets.cainjector].limits.cpu, "256m")
      )
      limit_memory = coalesce(
        var.cert_manager_cainjector_limit_memory,
        try(var.resources_config[local.cert_manager_presets.cainjector].limits.memory, "512Mi")
      )
    }

    controller = {
      request_cpu = coalesce(
        var.cert_manager_controller_request_cpu,
        try(var.resources_config[local.cert_manager_presets.controller].requests.cpu, "64m")
      )
      request_memory = coalesce(
        var.cert_manager_controller_request_memory,
        try(var.resources_config[local.cert_manager_presets.controller].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.cert_manager_controller_limit_cpu,
        try(var.resources_config[local.cert_manager_presets.controller].limits.cpu, "256m")
      )
      limit_memory = coalesce(
        var.cert_manager_controller_limit_memory,
        try(var.resources_config[local.cert_manager_presets.controller].limits.memory, "512Mi")
      )
    }
  }
}