// =========================
// Jenkins deployment rollout webhook tokens
// =========================
// Used by Jenkins pipeline jobs for Kani Interface, Coordinator, and Observer.

variable "kani_interface_deployment_rollout_webhook_token" {
  type        = string
  description = "Webhook token for Kani Interface deployment rollout pipeline"
  sensitive   = true
}

variable "kani_coordinator_deployment_rollout_webhook_token" {
  type        = string
  description = "Webhook token for Kani Coordinator deployment rollout pipeline"
  sensitive   = true
}

variable "kani_observer_deployment_rollout_webhook_token" {
  type        = string
  description = "Webhook token for Kani Observer deployment rollout pipeline"
  sensitive   = true
}