// =========================
// External Secrets replica count variables
// =========================

variable "external_secrets_operator_replica_count" {
  type        = number
  description = "Number of External Secrets operator replicas"
  default     = 1
}

variable "external_secrets_webhook_replica_count" {
  type        = number
  description = "Number of External Secrets webhook replicas"
  default     = 1
}

variable "external_secrets_cert_controller_replica_count" {
  type        = number
  description = "Number of External Secrets cert controller replicas"
  default     = 1
}

// =========================
// External Secrets resource variables
// =========================
// Controls resource allocation for External Secrets.

variable "external_secrets_request_cpu" {
  type        = string
  description = "CPU resource request for External Secrets"
  nullable    = true
  default     = null
}

variable "external_secrets_request_memory" {
  type        = string
  description = "Memory resource request for External Secrets"
  nullable    = true
  default     = null
}

variable "external_secrets_limit_cpu" {
  type        = string
  description = "CPU resource limit for External Secrets"
  nullable    = true
  default     = null
}

variable "external_secrets_limit_memory" {
  type        = string
  description = "Memory resource limit for External Secrets"
  nullable    = true
  default     = null
}

variable "webhook_request_cpu" {
  type        = string
  description = "CPU resource request for Webhook"
  nullable    = true
  default     = null
}

variable "webhook_request_memory" {
  type        = string
  description = "Memory resource request for Webhook"
  nullable    = true
  default     = null
}

variable "webhook_limit_cpu" {
  type        = string
  description = "CPU resource limit for Webhook"
  nullable    = true
  default     = null
}

variable "webhook_limit_memory" {
  type        = string
  description = "Memory resource limit for Webhook"
  nullable    = true
  default     = null
}

variable "cert_controller_request_cpu" {
  type        = string
  description = "CPU resource request for Cert Controller"
  nullable    = true
  default     = null
}

variable "cert_controller_request_memory" {
  type        = string
  description = "Memory resource request for Cert Controller"
  nullable    = true
  default     = null
}

variable "cert_controller_limit_cpu" {
  type        = string
  description = "CPU resource limit for Cert Controller"
  nullable    = true
  default     = null
}

variable "cert_controller_limit_memory" {
  type        = string
  description = "Memory resource limit for Cert Controller"
  nullable    = true
  default     = null
}

variable "app_secret_version" {
  type        = number
  description = "App secret version"
}

variable "rpcs_secret_version" {
  type        = number
  description = "RPCs secret version"
}

locals {
  external_secrets_presets = {
    external_secrets  = "16"
    webhook           = "16"
    cert_controller   = "16"
  }
}

locals {
  external_secrets = {
    external_secrets = {
      request_cpu = coalesce(
        var.external_secrets_request_cpu,
        try(var.resources_config[local.external_secrets_presets.external_secrets].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.external_secrets_request_memory,
        try(var.resources_config[local.external_secrets_presets.external_secrets].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.external_secrets_limit_cpu,
        try(var.resources_config[local.external_secrets_presets.external_secrets].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.external_secrets_limit_memory,
        try(var.resources_config[local.external_secrets_presets.external_secrets].limits.memory, "256Mi")
      )
    }
    webhook = {
      request_cpu = coalesce(
        var.webhook_request_cpu,
        try(var.resources_config[local.external_secrets_presets.webhook].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.webhook_request_memory,
        try(var.resources_config[local.external_secrets_presets.webhook].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.webhook_limit_cpu,
        try(var.resources_config[local.external_secrets_presets.webhook].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.webhook_limit_memory,
        try(var.resources_config[local.external_secrets_presets.webhook].limits.memory, "256Mi")
      )
    }
    cert_controller = {
      request_cpu = coalesce(
        var.cert_controller_request_cpu,
        try(var.resources_config[local.external_secrets_presets.cert_controller].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.cert_controller_request_memory,
        try(var.resources_config[local.external_secrets_presets.cert_controller].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.cert_controller_limit_cpu,
        try(var.resources_config[local.external_secrets_presets.cert_controller].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.cert_controller_limit_memory,
        try(var.resources_config[local.external_secrets_presets.cert_controller].limits.memory, "256Mi")
      )
    }
  }
}
