variable "kani_interface_deployment_rollout_webhook_token" {
  type = string
  description = "Webhook token for Kani Interface Deployment Rollout"
  sensitive = true
}

variable "kani_coordinator_deployment_rollout_webhook_token" {
  type = string
  description = "Webhook token for Kani Coordinator Deployment Rollout"
  sensitive = true
}