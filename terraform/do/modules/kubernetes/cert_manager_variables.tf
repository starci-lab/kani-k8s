# Cert Manager
# =========================
variable "cert_manager_cert_manager_request_cpu" {
  type        = string
  description = "Requested CPU for cert manager"
  default     = "64m"
}

variable "cert_manager_cert_manager_request_memory" {
  type        = string
  description = "Requested memory for cert manager"
  default     = "128Mi"
}

variable "cert_manager_cert_manager_limit_cpu" {
  type        = string
  description = "CPU limit for cert manager"
  default     = "128m"
}

variable "cert_manager_cert_manager_limit_memory" {
  type        = string
  description = "Memory limit for cert manager"
  default     = "256Mi"
}
# Webhook
# =========================
variable "cert_manager_webhook_request_cpu" {
  type        = string
  description = "Requested CPU for webhook"
  default     = "64m"
}

variable "cert_manager_webhook_request_memory" {
  type        = string
  description = "Requested memory for webhook"
  default     = "128Mi"
}

variable "cert_manager_webhook_limit_cpu" {
  type        = string
  description = "CPU limit for webhook"
  default     = "128m"
}

variable "cert_manager_webhook_limit_memory" {
  type        = string
  description = "Memory limit for webhook"
  default     = "256Mi"
}
# CA Injector
# =========================
variable "cert_manager_cainjector_request_cpu" {
  type        = string
  description = "Requested CPU for cainjector"
  default     = "64m"
}

variable "cert_manager_cainjector_request_memory" {
  type        = string
  description = "Requested memory for cainjector"
  default     = "128Mi"
}

variable "cert_manager_cainjector_limit_cpu" {
  type        = string
  description = "CPU limit for cainjector"
  default     = "128m"
}

variable "cert_manager_cainjector_limit_memory" {
  type        = string
  description = "Memory limit for cainjector"
  default     = "256Mi"
}

# Controller
# =========================
variable "cert_manager_controller_request_cpu" {
  type        = string
  description = "Requested CPU for controller"
  default     = "64m"   
}

variable "cert_manager_controller_request_memory" {
  type        = string
  description = "Requested memory for controller"
  default     = "128Mi"
}

variable "cert_manager_controller_limit_cpu" {
  type        = string
  description = "CPU limit for controller"
  default     = "128m"
}

variable "cert_manager_controller_limit_memory" {
  type        = string
  description = "Memory limit for controller"
  default     = "256Mi"
}