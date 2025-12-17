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
  default = "s-4vcpu-8gb"
}

variable "kubernetes_node_pool_node_count" {
  type = number
  description = "Number of nodes in the node pool"
  default = 1
}

variable "mongodb_root_password" {
  type = string
  description = "Root password for MongoDB"
  sensitive = true
}

variable "redis_password" {
  type = string
  description = "Password for Redis"
  sensitive = true
}

variable "mongodb_shards" {
  type = number
  description = "Number of shards for MongoDB"
  default = 1
}

variable "argo_cd_admin_password" {
  type = string
  description = "Admin password for Argo CD"
  sensitive = true
}

variable "kafka_sasl_user" {
  type = string
  description = "SASL user for Kafka"
  default = "kani-kafka-user"
}

variable "kafka_sasl_password" {
  type = string
  description = "SASL password for Kafka"
  sensitive = true
}