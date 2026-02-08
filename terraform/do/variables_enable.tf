// =========================
// Feature toggle variables
// =========================
// Controls whether optional components are deployed by Terraform.

// Whether to deploy the Redis Cluster for distributed caching and queue management
variable "enable_redis_cluster" {
  type        = bool
  description = "Whether to deploy the Redis Cluster"
  default     = false
}
