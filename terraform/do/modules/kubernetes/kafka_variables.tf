# =========================
# Authentication
# =========================
variable "kafka_sasl_user" {
  type        = string
  description = "SASL user for Kafka"
  default     = "kani-kafka-user"
}

variable "kafka_sasl_password" {
  type        = string
  description = "SASL password for Kafka"
  sensitive   = true
}
# =========================
# Limits
# =========================
variable "kafka_limit_cpu" {
  type        = string
  description = "CPU limit for Kafka"
  default     = "512m"
}

variable "kafka_limit_memory" {
  type        = string
  description = "Memory limit for Kafka"
  default     = "1024Mi"
}

# =========================
# Controller
# =========================
variable "kafka_controller_request_cpu" {
  type        = string
  description = "Requested CPU for Kafka Controller"
  default     = "384m"
}

variable "kafka_controller_request_memory" {
  type        = string
  description = "Requested memory for Kafka Controller"
  default     = "768Mi"
}

variable "kafka_controller_limit_cpu" {
  type        = string
  description = "CPU limit for Kafka Controller"
  default     = "768m"
}

variable "kafka_controller_limit_memory" {
  type        = string
  description = "Memory limit for Kafka Controller"
  default     = "1536Mi"
}

variable "kafka_controller_persistence_size" {  
  type        = string
  description = "Persistent volume size for Kafka Controller"
  default     = "8Gi"
}

variable "kafka_controller_log_persistence_size" {
  type        = string
  description = "Persistent volume size for Kafka Controller logs"
  default     = "4Gi"
}

variable "kafka_broker_request_cpu" {   
  type        = string
  description = "Requested CPU for Kafka Broker"
  default     = "256m"
}

variable "kafka_broker_request_memory" {
  type        = string
  description = "Requested memory for Kafka Broker"
  default     = "512Mi"
}

variable "kafka_broker_limit_cpu" {
  type        = string
  description = "CPU limit for Kafka Broker"
  default     = "512m"
}

variable "kafka_broker_limit_memory" {
  type        = string
  description = "Memory limit for Kafka Broker"
  default     = "1024Mi"
}

# =========================
# Volume permissions
# =========================
variable "volume_permissions_request_cpu" {
  type        = string
  description = "Requested CPU for volume permissions"
  default     = "64m"
}

variable "volume_permissions_request_memory" {
  type        = string
  description = "Requested memory for volume permissions"
  default     = "128Mi" 
}

variable "volume_permissions_limit_cpu" {
  type        = string
  description = "CPU limit for volume permissions"
  default     = "128m"
}

variable "volume_permissions_limit_memory" {
  type        = string
  description = "Memory limit for volume permissions"
  default     = "256Mi"
}