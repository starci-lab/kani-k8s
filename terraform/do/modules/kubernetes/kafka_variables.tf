// =========================
// Kafka authentication variables
// =========================
// Controls SASL authentication used by Kafka clients and brokers.

variable "kafka_sasl_user" {
  type        = string
  description = "SASL authentication username used by Kafka clients and brokers"
  default     = "kani-kafka-user"
}

variable "kafka_sasl_password" {
  type        = string
  description = "SASL authentication password for Kafka"
  sensitive   = true
}

// =========================
// Kafka controller variables
// =========================
// Controls resource allocation and persistence for Kafka controllers.

variable "kafka_controller_request_cpu" {
  type        = string
  description = "CPU resource request for the Kafka controller"
  nullable    = true
  default     = null
}

variable "kafka_controller_request_memory" {
  type        = string
  description = "Memory resource request for the Kafka controller"
  nullable    = true
  default     = null
}

variable "kafka_controller_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Kafka controller"
  nullable    = true
  default     = null
}

variable "kafka_controller_limit_memory" {
  type        = string
  description = "Memory resource limit for the Kafka controller"
  nullable    = true
  default     = null
}

variable "kafka_controller_persistence_size" {
  type        = string
  description = "Persistent volume size for Kafka controller data"
  default     = "8Gi"
}

variable "kafka_controller_log_persistence_size" {
  type        = string
  description = "Persistent volume size for Kafka controller log data"
  default     = "4Gi"
}

variable "kafka_broker_replica_count" {
  type        = number
  description = "Number of Kafka broker-only nodes"
  default     = 1
}

variable "kafka_ui_request_cpu" {
  type        = string
  description = "CPU resource request for Kafka UI"
  nullable    = true
  default     = null
}

variable "kafka_ui_request_memory" {
  type        = string
  description = "Memory resource request for Kafka UI"
  nullable    = true
  default     = null
}

variable "kafka_ui_limit_cpu" {
  type        = string
  description = "CPU resource limit for Kafka UI"
  nullable    = true
  default     = null
}

variable "kafka_ui_limit_memory" {
  type        = string
  description = "Memory resource limit for Kafka UI"
  nullable    = true
  default     = null
}

// =========================
// Kafka broker variables
// =========================
// Controls resource allocation for Kafka broker nodes.

variable "kafka_broker_request_cpu" {
  type        = string
  description = "CPU resource request for Kafka brokers"
  nullable    = true
  default     = null
}

variable "kafka_broker_request_memory" {
  type        = string
  description = "Memory resource request for Kafka brokers"
  nullable    = true
  default     = null
}

variable "kafka_broker_limit_cpu" {
  type        = string
  description = "CPU resource limit for Kafka brokers"
  nullable    = true
  default     = null
}

variable "kafka_broker_limit_memory" {
  type        = string
  description = "Memory resource limit for Kafka brokers"
  nullable    = true
  default     = null
}

// =========================
// Volume permissions variables
// =========================
// Controls the init container responsible for setting filesystem
// permissions on Kafka persistent volumes.

variable "volume_permissions_request_cpu" {
  type        = string
  description = "CPU resource request for the volume permissions init container"
  nullable    = true
  default     = null
}

variable "volume_permissions_request_memory" {
  type        = string
  description = "Memory resource request for the volume permissions init container"
  nullable    = true
  default     = null
}

variable "volume_permissions_limit_cpu" {
  type        = string
  description = "CPU resource limit for the volume permissions init container"
  nullable    = true
  default     = null
}

variable "volume_permissions_limit_memory" {
  type        = string
  description = "Memory resource limit for the volume permissions init container"
  nullable    = true
  default     = null
}

locals {
  kafka_presets = {
    controller        = "192"
    broker            = "192"
    volume_permissions = "16"
    kafka_ui          = "64"
  }
}

locals {
  kafka = {
    controller = {
      request_cpu = coalesce(
        var.kafka_controller_request_cpu,
        try(var.resources_config[local.kafka_presets.controller].requests.cpu, "192m")
      )
      request_memory = coalesce(
        var.kafka_controller_request_memory,
        try(var.resources_config[local.kafka_presets.controller].requests.memory, "384Mi")
      )
      limit_cpu = coalesce(
        var.kafka_controller_limit_cpu,
        try(var.resources_config[local.kafka_presets.controller].limits.cpu, "768m")
      )
      limit_memory = coalesce(
        var.kafka_controller_limit_memory,
        try(var.resources_config[local.kafka_presets.controller].limits.memory, "1536Mi")
      )
    }

    broker = {
      request_cpu = coalesce(
        var.kafka_broker_request_cpu,
        try(var.resources_config[local.kafka_presets.broker].requests.cpu, "192m")
      )
      request_memory = coalesce(
        var.kafka_broker_request_memory,
        try(var.resources_config[local.kafka_presets.broker].requests.memory, "384Mi")
      )
      limit_cpu = coalesce(
        var.kafka_broker_limit_cpu,
        try(var.resources_config[local.kafka_presets.broker].limits.cpu, "768m")
      )
      limit_memory = coalesce(
        var.kafka_broker_limit_memory,
        try(var.resources_config[local.kafka_presets.broker].limits.memory, "1536Mi")
      )
    }

    volume_permissions = {
      request_cpu = coalesce(
        var.volume_permissions_request_cpu,
        try(var.resources_config[local.kafka_presets.volume_permissions].requests.cpu, "32m")
      )
      request_memory = coalesce(
        var.volume_permissions_request_memory,
        try(var.resources_config[local.kafka_presets.volume_permissions].requests.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.volume_permissions_limit_cpu,
        try(var.resources_config[local.kafka_presets.volume_permissions].limits.cpu, "128m")
      )
      limit_memory = coalesce(
        var.volume_permissions_limit_memory,
        try(var.resources_config[local.kafka_presets.volume_permissions].limits.memory, "256Mi")
      )
    }

    kafka_ui = {
      request_cpu = coalesce(
        var.kafka_ui_request_cpu,
        try(var.resources_config[local.kafka_presets.kafka_ui].requests.cpu, "16m")
      )
      request_memory = coalesce(
        var.kafka_ui_request_memory,
        try(var.resources_config[local.kafka_presets.kafka_ui].requests.memory, "32Mi")
      )
      limit_memory = coalesce(
        var.kafka_ui_limit_memory,
        try(var.resources_config[local.kafka_presets.kafka_ui].limits.memory, "64Mi")
      )
      limit_cpu = coalesce(
        var.kafka_ui_limit_cpu,
        try(var.resources_config[local.kafka_presets.kafka_ui].limits.cpu, "32m")
      )
    }
  }
}