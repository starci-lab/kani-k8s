// =========================
// Kubernetes cluster variables
// =========================

variable "kubernetes_name" {
  type        = string
  description = "Name of the Kubernetes cluster to be created on DigitalOcean"
  default     = "kani-kubernetes"
}

variable "kubernetes_region" {
  type        = string
  description = "DigitalOcean region where the Kubernetes cluster will be provisioned"
  default     = "sgp1"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version used for the cluster (must be supported by DigitalOcean)"
  default     = "1.34.1-do.2"
}

// =========================
// Kubernetes primary node pool variables
// =========================

variable "kubernetes_primary_node_pool_name" {
  type        = string
  description = "Name of the primary node pool for the Kubernetes cluster"
  default     = "kani-primary-node-pool"
}

variable "kubernetes_primary_node_pool_size" {
  type        = string
  description = "Droplet size (instance type) used for nodes in the primary node pool"
  default     = "s-4vcpu-8gb"
}

variable "kubernetes_primary_node_pool_node_count" {
  type        = number
  description = "Number of worker nodes provisioned in the primary node pool"
  default     = 1
}