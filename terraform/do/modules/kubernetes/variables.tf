variable "kubernetes_name" {
  type = string
  description = "Name of the Kubernetes cluster"
  default = "kani"
}

variable "kubernetes_region" {
  type = string
  description = "Region of the Kubernetes cluster"
  default = "sgp1"
}

variable "kubernetes_version" {
  type = string
  description = "Version of the Kubernetes cluster"
  default = "1.31.1"
}

variable "kubernetes_node_pool_name" {
  type = string
  description = "Name of the node pool"
  default = "kani-node-pool"
}

variable "kubernetes_node_pool_size" {
  type = string
  description = "Size of the node pool"
  default = "s-1vcpu-2gb"
}

variable "kubernetes_node_pool_node_count" {
  type = number
  description = "Number of nodes in the node pool"
  default = 2
}

variable "workload_node_pool_label" {
  type        = string
  description = "Label of the workload node pool"
  default     = "kani-workload-node-pool"
}

variable "argo_cd_domain_name" {
  type = string
  description = "Domain name of the Argo CD server"
}

variable "base_domain_name" {
  type = string
  description = "Base domain name"
  default = "kanibot.xyz"
}