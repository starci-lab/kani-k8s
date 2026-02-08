// =========================
// GCP project ID variables
// =========================
// Controls the GCP project ID used by External Secrets.
variable "gcp_project_id" {
  type        = string
  description = "GCP project ID"
  sensitive   = true
}