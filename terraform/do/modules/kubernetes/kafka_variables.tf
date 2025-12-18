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
  default     = "192m"
}

variable "kafka_controller_request_memory" {
  type        = string
  description = "Memory resource request for the Kafka controller"
  default     = "384Mi"
}

variable "kafka_controller_limit_cpu" {
  type        = string
  description = "CPU resource limit for the Kafka controller"
  default     = "768m"
}

variable "kafka_controller_limit_memory" {
  type        = string
  description = "Memory resource limit for the Kafka controller"
  default     = "1536Mi"
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

// =========================
// Kafka broker variables
// =========================
// Controls resource allocation for Kafka broker nodes.

variable "kafka_broker_request_cpu" {
  type        = string
  description = "CPU resource request for Kafka brokers"
  default     = "128m"
}

variable "kafka_broker_request_memory" {
  type        = string
  description = "Memory resource request for Kafka brokers"
  default     = "256Mi"
}

variable "kafka_broker_limit_cpu" {
  type        = string
  description = "CPU resource limit for Kafka brokers"
  default     = "512m"
}

variable "kafka_broker_limit_memory" {
  type        = string
  description = "Memory resource limit for Kafka brokers"
  default     = "1024Mi"
}

// =========================
// Volume permissions variables
// =========================
// Controls the init container responsible for setting filesystem
// permissions on Kafka persistent volumes.

variable "volume_permissions_request_cpu" {
  type        = string
  description = "CPU resource request for the volume permissions init container"
  default     = "32m"
}

variable "volume_permissions_request_memory" {
  type        = string
  description = "Memory resource request for the volume permissions init container"
  default     = "64Mi"
}

variable "volume_permissions_limit_cpu" {
  type        = string
  description = "CPU resource limit for the volume permissions init container"
  default     = "128m"
}

variable "volume_permissions_limit_memory" {
  type        = string
  description = "Memory resource limit for the volume permissions init container"
  default     = "256Mi"
}