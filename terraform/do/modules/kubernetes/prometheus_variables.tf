// =========================
// Prometheus Operator resource variables
// =========================
// Controls resource allocation for the Prometheus Operator.

variable "operator_request_cpu" {
  type        = string
  description = "CPU resource request for the Prometheus Operator"
  nullable    = true
  default     = null
}

variable "operator_request_memory" {
  type        = string
  description = "Memory resource request for the Prometheus Operator"
  nullable    = true
  default     = null
}

variable "operator_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Prometheus Operator"
  nullable    = true
  default     = null
}

variable "operator_limit_memory" {
  type        = string
  description = "Memory resource limit for the Prometheus Operator"
  nullable    = true
  default     = null
}

// =========================
// Prometheus resource variables
// =========================
// Controls resource allocation for Prometheus server.

variable "prometheus_request_cpu" {
  type        = string
  description = "CPU resource request for Prometheus server"
  nullable    = true
  default     = null
}

variable "prometheus_request_memory" {
  type        = string
  description = "Memory resource request for Prometheus server"
  nullable    = true
  default     = null
}

variable "prometheus_limit_cpu" {
  type        = string
  description = "CPU resource limit for Prometheus server"
  nullable    = true
  default     = null
}

variable "prometheus_limit_memory" {
  type        = string
  description = "Memory resource limit for Prometheus server"
  nullable    = true
  default     = null
}

variable "prometheus_persistence_size" {
  type        = string
  description = "Persistent volume size for Prometheus data"
  default     = "2Gi"
}

// =========================
// Thanos Sidecar resource variables
// =========================
// Controls resource allocation for Thanos sidecar container.

variable "thanos_request_cpu" {
  type        = string
  description = "CPU resource request for Thanos sidecar"
  nullable    = true
  default     = null
}

variable "thanos_request_memory" {
  type        = string
  description = "Memory resource request for Thanos sidecar"
  nullable    = true
  default     = null
}

variable "thanos_limit_cpu" {
  type        = string
  description = "CPU resource limit for Thanos sidecar"
  nullable    = true
  default     = null
}

variable "thanos_limit_memory" {
  type        = string
  description = "Memory resource limit for Thanos sidecar"
  nullable    = true
  default     = null
}

// =========================
// Alertmanager resource variables
// =========================
// Controls resource allocation for Alertmanager.

variable "alertmanager_request_cpu" {
  type        = string
  description = "CPU resource request for Alertmanager"
  nullable    = true
  default     = null
}

variable "alertmanager_request_memory" {
  type        = string
  description = "Memory resource request for Alertmanager"
  nullable    = true
  default     = null
}

variable "alertmanager_limit_cpu" {
  type        = string
  description = "CPU resource limit for Alertmanager"
  nullable    = true
  default     = null
}

variable "alertmanager_limit_memory" {
  type        = string
  description = "Memory resource limit for Alertmanager"
  nullable    = true
  default     = null
}

variable "alertmanager_persistence_size" {
  type        = string
  description = "Persistent volume size for Alertmanager data"
  default     = "2Gi"
}


// =========================
// Blackbox Exporter resource variables
// =========================
// Controls resource allocation for Blackbox Exporter.

variable "blackbox_exporter_request_cpu" {
  type        = string
  description = "CPU resource request for Blackbox Exporter"
  nullable    = true
  default     = null
}

variable "blackbox_exporter_request_memory" {
  type        = string
  description = "Memory resource request for Blackbox Exporter"
  nullable    = true
  default     = null
}

variable "blackbox_exporter_limit_cpu" {
  type        = string
  description = "CPU resource limit for Blackbox Exporter"
  nullable    = true
  default     = null
}

variable "blackbox_exporter_limit_memory" {
  type        = string
  description = "Memory resource limit for Blackbox Exporter"
  nullable    = true
  default     = null
}

// =========================
// Thanos Ruler resource variables
// =========================
// Controls resource allocation for Thanos Ruler.

variable "thanos_ruler_request_cpu" {
  type        = string
  description = "CPU resource request for Thanos Ruler"
  nullable    = true
  default     = null
}

variable "thanos_ruler_request_memory" {
  type        = string
  description = "Memory resource request for Thanos Ruler"
  nullable    = true
  default     = null
}

variable "thanos_ruler_limit_cpu" {
  type        = string
  description = "CPU resource limit for Thanos Ruler"
  nullable    = true
  default     = null
}

variable "thanos_ruler_limit_memory" {
  type        = string
  description = "Memory resource limit for Thanos Ruler"
  nullable    = true
  default     = null
}

// =========================
// Prometheus Basic Auth variables
// =========================
// Controls basic authentication for Prometheus ingress.
variable "prometheus_htpasswd" {
  type        = string
  description = "HTPASSWD for Prometheus basic authentication"
  sensitive   = true
}

variable "prometheus_alertmanager_htpasswd" {
  type        = string
  description = "HTPASSWD for Prometheus Alertmanager basic authentication"
  sensitive   = true
}

variable "kafka_ui_htpasswd" {
  type        = string
  description = "HTPASSWD for Kafka UI basic authentication"
  sensitive   = true
}

locals {
  prometheus_presets = {
    operator          = "16"
    prometheus        = "32"
    thanos            = "16"
    alertmanager      = "16"
    blackbox_exporter = "16"
    thanos_ruler      = "16"
  }
}

locals {
  prometheus = {
    operator = {
      request_cpu = coalesce(
        var.operator_request_cpu,
        try(var.resources_config[local.prometheus_presets.operator].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.operator_request_memory,
        try(var.resources_config[local.prometheus_presets.operator].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.operator_limit_cpu,
        try(var.resources_config[local.prometheus_presets.operator].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.operator_limit_memory,
        try(var.resources_config[local.prometheus_presets.operator].limits.memory, "512Mi")
      )
    }

    prometheus = {
      request_cpu = coalesce(
        var.prometheus_request_cpu,
        try(var.resources_config[local.prometheus_presets.prometheus].requests.cpu, "64m")
      )
      request_memory = coalesce(
        var.prometheus_request_memory,
        try(var.resources_config[local.prometheus_presets.prometheus].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.prometheus_limit_cpu,
        try(var.resources_config[local.prometheus_presets.prometheus].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.prometheus_limit_memory,
        try(var.resources_config[local.prometheus_presets.prometheus].limits.memory, "512Mi")
      )
    }

    thanos = {
      request_cpu = coalesce(
        var.thanos_request_cpu,
        try(var.resources_config[local.prometheus_presets.thanos].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.thanos_request_memory,
        try(var.resources_config[local.prometheus_presets.thanos].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.thanos_limit_cpu,
        try(var.resources_config[local.prometheus_presets.thanos].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.thanos_limit_memory,
        try(var.resources_config[local.prometheus_presets.thanos].limits.memory, "256Mi")
      )
    }

    alertmanager = {
      request_cpu = coalesce(
        var.alertmanager_request_cpu,
        try(var.resources_config[local.prometheus_presets.alertmanager].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.alertmanager_request_memory,
        try(var.resources_config[local.prometheus_presets.alertmanager].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.alertmanager_limit_cpu,
        try(var.resources_config[local.prometheus_presets.alertmanager].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.alertmanager_limit_memory,
        try(var.resources_config[local.prometheus_presets.alertmanager].limits.memory, "256Mi")
      )
    }

    blackbox_exporter = {
      request_cpu = coalesce(
        var.blackbox_exporter_request_cpu,
        try(var.resources_config[local.prometheus_presets.blackbox_exporter].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.blackbox_exporter_request_memory,
        try(var.resources_config[local.prometheus_presets.blackbox_exporter].requests.memory, "32Mi")
      )
      limit_cpu = coalesce(
        var.blackbox_exporter_limit_cpu,
        try(var.resources_config[local.prometheus_presets.blackbox_exporter].limits.cpu, "64m")
      )
      limit_memory = coalesce(
        var.blackbox_exporter_limit_memory,
        try(var.resources_config[local.prometheus_presets.blackbox_exporter].limits.memory, "128Mi")
      )
    }

    thanos_ruler = {
      request_cpu = coalesce(
        var.thanos_ruler_request_cpu,
        try(var.resources_config[local.prometheus_presets.thanos_ruler].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.thanos_ruler_request_memory,
        try(var.resources_config[local.prometheus_presets.thanos_ruler].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.thanos_ruler_limit_cpu,
        try(var.resources_config[local.prometheus_presets.thanos_ruler].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.thanos_ruler_limit_memory,
        try(var.resources_config[local.prometheus_presets.thanos_ruler].limits.memory, "256Mi")
      )
    }
  }
}