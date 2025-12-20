// =========================
// Kani Interface application configuration
// =========================
// Controls basic application settings like replica count and port.

variable "kani_interface_replica_count" {
  type        = number
  description = "Number of pod replicas for Kani Interface"
  default     = 1
}

variable "kani_interface_port" {
  type        = number
  description = "Port number for Kani Interface application"
  default     = 3000
}

// =========================
// Primary MongoDB configuration
// =========================
// Configures connection to the primary MongoDB database.

variable "kani_interface_primary_mongodb_port" {
  type        = number
  description = "Port number for primary MongoDB database"
  default     = 27017
}

variable "kani_interface_primary_mongodb_database" {
  type        = string
  description = "Database name for primary MongoDB"
  default     = "kani"
}

// =========================
// Kafka configuration
// =========================
// Configures connection to Kafka broker for message queuing.

variable "kani_interface_kafka_broker_port" {
  type        = number
  description = "Port number for Kafka broker"
  default     = 9092
}

variable "kani_interface_kafka_sasl_enabled" {
  type        = string
  description = "Enable SASL authentication for Kafka (true/false)"
  default     = "true"
}

// =========================
// Kani Interface resource variables
// =========================
// Controls resource allocation for Kani Interface pods.

variable "kani_interface_request_cpu" {
  type        = string
  description = "CPU resource request for Kani Interface"
  nullable    = true
  default     = null
}

variable "kani_interface_request_memory" {
  type        = string
  description = "Memory resource request for Kani Interface"
  nullable    = true
  default     = null
}

variable "kani_interface_limit_cpu" {
  type        = string
  description = "CPU resource limit for Kani Interface"
  nullable    = true
  default     = null
}

variable "kani_interface_limit_memory" {
  type        = string
  description = "Memory resource limit for Kani Interface"
  nullable    = true
  default     = null
}

// =========================
// Kani Interface resource presets
// =========================
// Defines preset resource configurations that can be referenced
// via the resources_config variable.

locals {
  kani_interface_presets = {
    kani_interface = "64"
  }
}

// =========================
// Kani Interface resource configuration
// =========================
// Resolves resource requests and limits using either explicit
// variables or fallback to preset configurations from resources_config.

locals {
  kani_interface = {
    kani_interface = {
      request_cpu = coalesce(
        var.kani_interface_request_cpu,
        try(var.resources_config[local.kani_interface_presets.kani_interface].requests.cpu, "100m")
      )
      request_memory = coalesce(
        var.kani_interface_request_memory,
        try(var.resources_config[local.kani_interface_presets.kani_interface].requests.memory, "128Mi")
      )
      limit_cpu = coalesce(
        var.kani_interface_limit_cpu,
        try(var.resources_config[local.kani_interface_presets.kani_interface].limits.cpu, "200m")
      )
      limit_memory = coalesce(
        var.kani_interface_limit_memory,
        try(var.resources_config[local.kani_interface_presets.kani_interface].limits.memory, "256Mi")
      )
    }
  }
}

