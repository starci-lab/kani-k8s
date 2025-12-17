# Digital Ocean variables
variable "digitalocean_token" {
  type = string
  description = "Digital Ocean API token"
  sensitive = true
}

# Kubernetes variables
variable "kubernetes_name" {
  type = string
  description = "Name of the Kubernetes cluster"
  default = "kani-kubernetes"
}

variable "kubernetes_region" {
  type = string
  description = "Region of the Kubernetes cluster"
  default = "sgp1"
}

variable "kubernetes_version" {
  type = string
  description = "Version of the Kubernetes cluster"
  default = "1.34.1-do.1"
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

variable "mongodb_root_password" {
  type = string
  description = "Root password for MongoDB"
  sensitive = true
}