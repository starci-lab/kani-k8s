// =========================
// Kubernetes cluster variables
// =========================

// Name of the Kubernetes cluster to be created on DigitalOcean
variable "kubernetes_name" {
  type        = string
  description = "Name of the Kubernetes cluster to be created on DigitalOcean"
  default     = "kani-kubernetes"
}

// DigitalOcean region where the Kubernetes cluster will be provisioned
variable "kubernetes_region" {
  type        = string
  description = "DigitalOcean region where the Kubernetes cluster will be provisioned"
  default     = "sfo2"
}

// Kubernetes version used for the cluster (must be supported by DigitalOcean)
variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version used for the cluster (must be supported by DigitalOcean)"
  default     = "1.33.6-do.3"
}

// =========================
// Kubernetes primary node pool variables
// =========================

// Name of the primary node pool for the Kubernetes cluster
variable "kubernetes_primary_node_pool_name" {
  type        = string
  description = "Name of the primary node pool for the Kubernetes cluster"
  default     = "kani-primary-node-pool"
}

// Droplet size (instance type) used for nodes in the primary node pool
variable "kubernetes_primary_node_pool_size" {
  type        = string
  description = "Droplet size (instance type) used for nodes in the primary node pool"
  default     = "s-4vcpu-8gb"
}

// Number of worker nodes provisioned in the primary node pool
variable "kubernetes_primary_node_pool_node_count" {
  type        = number
  description = "Number of worker nodes provisioned in the primary node pool"
  default     = 2
}
