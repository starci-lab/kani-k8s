// =========================
// Feature toggle variables
// =========================
// Controls whether optional components are deployed by Terraform.

variable "enable_redis_cluster" {
  type        = bool
  description = "Whether to deploy the Redis Cluster"
  default     = false
}