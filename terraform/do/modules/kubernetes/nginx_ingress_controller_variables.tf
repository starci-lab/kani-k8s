variable "nginx_ingress_controller_request_cpu" {
  type        = string
  description = "Requested CPU for nginx ingress controller"
  default     = "128m"
}

variable "nginx_ingress_controller_request_memory" {
  type        = string
  description = "Requested memory for nginx ingress controller"
  default     = "256Mi"
}

variable "nginx_ingress_controller_limit_cpu" {
  type        = string
  description = "Limit CPU for nginx ingress controller"
  default     = "256m"
}

variable "nginx_ingress_controller_limit_memory" {
  type        = string
  description = "Limit memory for nginx ingress controller"
  default     = "512Mi"
}

variable "nginx_ingress_controller_default_backend_request_cpu" {
  type        = string
  description = "Requested CPU for default backend"
  default     = "64m"
}

variable "nginx_ingress_controller_default_backend_request_memory" {
  type        = string
  description = "Requested memory for default backend"
  default     = "128Mi"
}

variable "nginx_ingress_controller_default_backend_limit_cpu" {
  type        = string
  description = "Limit CPU for default backend"
  default     = "128m"
}

variable "nginx_ingress_controller_default_backend_limit_memory" {
  type        = string
  description = "Limit memory for default backend"
  default     = "256Mi"
}   