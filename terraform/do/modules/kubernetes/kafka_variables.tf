// =========================
// Kafka authentication variables
// =========================
// Controls SASL authentication used by Kafka clients and brokers.

// SASL authentication username used by Kafka clients and brokers
variable "kafka_sasl_user" {
  type        = string
  description = "SASL authentication username used by Kafka clients and brokers"
  default     = "kani-kafka-user"
}

// SASL authentication password for Kafka
variable "kafka_sasl_password" {
  type        = string
  description = "SASL authentication password for Kafka"
  sensitive   = true
}

// =========================
// Kafka controller only variables
// =========================
// Controls whether to run the controller as a standalone controller or controller+broker.

// Whether to run the controller as a standalone controller or controller+broker
variable "kafka_controller_only" {
  type        = bool
  description = "Whether to run the controller as a standalone controller or controller+broker"
  default     = false
}

// =========================
// Kafka controller variables
// =========================
// Controls resource allocation and persistence for Kafka controllers.

// CPU resource request for the Kafka controller
variable "kafka_controller_request_cpu" {
  type        = string
  description = "CPU resource request for the Kafka controller"
  nullable    = true
  default     = null
}

// Memory resource request for the Kafka controller
variable "kafka_controller_request_memory" {
  type        = string
  description = "Memory resource request for the Kafka controller"
  nullable    = true
  default     = null
}

// CPU resource limit for the Kafka controller
variable "kafka_controller_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Kafka controller"
  nullable    = true
  default     = null
}

// Memory resource limit for the Kafka controller
variable "kafka_controller_limit_memory" {
  type        = string
  description = "Memory resource limit for the Kafka controller"
  nullable    = true
  default     = null
}

// Persistent volume size for Kafka controller data
variable "kafka_controller_persistence_size" {
  type        = string
  description = "Persistent volume size for Kafka controller data"
  default     = "8Gi"
}

// Persistent volume size for Kafka controller log data
variable "kafka_controller_log_persistence_size" {
  type        = string
  description = "Persistent volume size for Kafka controller log data"
  default     = "4Gi"
}

// =========================
// Kafka broker variables
// =========================
// Controls resource allocation for Kafka broker nodes.

// Number of Kafka broker-only nodes
variable "kafka_broker_replica_count" {
  type        = number
  description = "Number of Kafka broker-only nodes"
  default     = 0
}

// Persistent volume size for Kafka broker data
variable "kafka_broker_persistence_size" {
  type        = string
  description = "Persistent volume size for Kafka broker data"
  default     = "8Gi"
}

// CPU resource request for Kafka brokers
variable "kafka_broker_request_cpu" {
  type        = string
  description = "CPU resource request for Kafka brokers"
  nullable    = true
  default     = null
}

// Memory resource request for Kafka brokers
variable "kafka_broker_request_memory" {
  type        = string
  description = "Memory resource request for Kafka brokers"
  nullable    = true
  default     = null
}

// CPU resource limit for Kafka brokers
variable "kafka_broker_limit_cpu" {
  type        = string
  description = "CPU resource limit for Kafka brokers"
  nullable    = true
  default     = null
}

// Memory resource limit for Kafka brokers
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

// CPU resource request for the volume permissions init container
variable "volume_permissions_request_cpu" {
  type        = string
  description = "CPU resource request for the volume permissions init container"
  nullable    = true
  default     = null
}

// Memory resource request for the volume permissions init container
variable "volume_permissions_request_memory" {
  type        = string
  description = "Memory resource request for the volume permissions init container"
  nullable    = true
  default     = null
}

// CPU resource limit for the volume permissions init container
variable "volume_permissions_limit_cpu" {
  type        = string
  description = "CPU resource limit for the volume permissions init container"
  nullable    = true
  default     = null
}

// Memory resource limit for the volume permissions init container
variable "volume_permissions_limit_memory" {
  type        = string
  description = "Memory resource limit for the volume permissions init container"
  nullable    = true
  default     = null
}

// =========================
// Kafka UI resource variables
// =========================
// Controls resource allocation for Kafka UI.

// CPU resource request for Kafka UI
variable "kafka_ui_request_cpu" {
  type        = string
  description = "CPU resource request for Kafka UI"
  nullable    = true
  default     = null
}

// Memory resource request for Kafka UI
variable "kafka_ui_request_memory" {
  type        = string
  description = "Memory resource request for Kafka UI"
  nullable    = true
  default     = null
}

// CPU resource limit for Kafka UI
variable "kafka_ui_limit_cpu" {
  type        = string
  description = "CPU resource limit for Kafka UI"
  nullable    = true
  default     = null
}

// Memory resource limit for Kafka UI
variable "kafka_ui_limit_memory" {
  type        = string
  description = "Memory resource limit for Kafka UI"
  nullable    = true
  default     = null
}
