// =========================
// Domain configuration variables
// =========================
// Defines the base domain and subdomain prefixes used
// to expose platform services via ingress and DNS.

variable "prefix_domain_name" {
  type        = string
  description = "Prefix for the domain name"
}

variable "domain_name" {
  type        = string
  description = "Base domain name used for all public-facing services (e.g. example.com)"
}

// =========================
// Argo CD domain configuration
// =========================

variable "argo_cd_prefix" {
  type        = string
  description = "Subdomain prefix for the Argo CD server (combined with domain_name)"
  default     = "argo-cd"
}

// =========================
// Prometheus domain configuration
// =========================

variable "prometheus_prefix" {
  type        = string
  description = "Subdomain prefix for the Prometheus server (combined with domain_name)"
  default     = "prometheus"
}

variable "prometheus_alertmanager_prefix" {
  type        = string
  description = "Subdomain prefix for the Prometheus Alertmanager server (combined with domain_name)"
  default     = "prometheus-alertmanager"
}

// =========================
// Grafana domain configuration
// =========================

variable "grafana_prefix" {
  type        = string
  description = "Subdomain prefix for the Grafana server (combined with domain_name)"
  default     = "grafana"
}

// =========================
// Portainer domain configuration
// =========================

variable "portainer_prefix" {
  type        = string
  description = "Subdomain prefix for the Portainer server (combined with domain_name)"
  default     = "portainer"
}

// =========================
// API domain configuration
// =========================

variable "api_prefix" {
  type        = string
  description = "Subdomain prefix for the API server (combined with domain_name)"
  default     = "api"
}

// =========================
// Jenkins domain configuration
// =========================

# variable "jenkins_prefix" {
#   type        = string
#   description = "Subdomain prefix for the Jenkins server (combined with domain_name)"
#   default     = "jenkins"
# }

// =========================
// Kafka UI domain configuration
// =========================

variable "kafka_ui_prefix" {
  type        = string
  description = "Subdomain prefix for the Kafka UI server (combined with domain_name)"
  default     = "kafka-ui"
}