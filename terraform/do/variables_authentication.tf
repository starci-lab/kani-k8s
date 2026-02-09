// =========================
// Kafka authentication (SASL) variables
// =========================

variable "kafka_sasl_user" {
  type        = string
  description = "SASL authentication username used by Kafka clients to authenticate and connect to the Kafka cluster"
  default     = "kani"
}

variable "kafka_sasl_password" {
  type        = string
  description = "SASL authentication password for the Kafka user; must be supplied securely (e.g., via tfvars, environment variables, or a secrets manager)"
  sensitive   = true
}

// =========================
// MongoDB authentication variables
// =========================

variable "mongodb_root_password" {
  type        = string
  description = "Password for the MongoDB administrative (root) user; must be provided securely (e.g., via tfvars, environment variables, or a secrets manager)"
  sensitive   = true
}

variable "mongodb_database" {
  type        = string
  description = "Name of the primary MongoDB database created during initialization and used by the application"
  default     = "kani"
}

// =========================
// Redis authentication variables
// =========================

variable "redis_password" {
  type        = string
  description = "Authentication password required for clients to connect to Redis; must be supplied securely (e.g., via tfvars, environment variables, or a secrets manager)"
  sensitive   = true
}

// =========================
// Argo CD authentication variables
// =========================

variable "argo_cd_admin_password" {
  type        = string
  description = "Administrative password for Argo CD; must be provided securely (e.g., via tfvars, environment variables, or a secrets manager)"
  sensitive   = true
}

// =========================
// kube-prometheus basic authentication variables
// =========================

variable "kube_prometheus_htpasswd" {
  type        = string
  description = "HTPASSWD for kube-prometheus basic authentication"
  sensitive   = true
}

variable "kube_prometheus_alertmanager_basic_auth_user" {
  type        = string
  description = "Username for kube-prometheus Alertmanager basic authentication"
  default     = "kani"
}

variable "kube_prometheus_alertmanager_basic_auth_password" {
  type        = string
  description = "Password for kube-prometheus Alertmanager basic authentication"
  sensitive   = true
}

variable "kube_prometheus_alertmanager_htpasswd" {
  type        = string
  description = "HTPASSWD for kube-prometheus Alertmanager basic authentication"
  sensitive   = true
}

variable "kube_prometheus_basic_auth_user" {
  type        = string
  description = "Username for kube-prometheus basic authentication"
  default     = "kani"
}

variable "kube_prometheus_basic_auth_password" {
  type        = string
  description = "Password for kube-prometheus basic authentication"
  sensitive   = true
}

// =========================
// Loki basic authentication variables
// =========================

variable "loki_gateway_htpasswd" {
  type        = string
  description = "HTPASSWD for Loki gateway basic authentication"
  sensitive   = true
}

variable "loki_basic_auth_user" {
  type        = string
  description = "Username for Loki basic authentication"
  default     = "kani"
}

variable "loki_basic_auth_password" {
  type        = string
  description = "Password for Loki basic authentication"
  sensitive   = true
}

// =========================
// Consul basic authentication variables
// =========================

variable "consul_htpasswd" {
  type        = string
  description = "HTPASSWD for Consul basic authentication"
  sensitive   = true
}

// =========================
// Kafka UI basic authentication variables
// =========================

variable "kafka_ui_htpasswd" {
  type        = string
  description = "HTPASSWD for Kafka UI basic authentication"
  sensitive   = true
}

// =========================
// Grafana basic authentication variables
// =========================

variable "grafana_user" {
  type        = string
  description = "Username for Grafana basic authentication"
  default     = "kani"
}

variable "grafana_password" {
  type        = string
  description = "Password for Grafana basic authentication"
  sensitive   = true
}

// =========================
// Jenkins authentication variables
// =========================

# variable "jenkins_user" {
#   type        = string
#   description = "Jenkins user"
#   sensitive = true
# }

// =========================
// Jenkins authentication variables
// =========================

# variable "jenkins_password" {
#   type        = string
#   description = "Jenkins password"
#   sensitive = true
# }