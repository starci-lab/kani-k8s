// =========================
// Kani CLI Restore Job Backup ID variables
// =========================
// Backup ID used to restore the database from a backup.
variable "kani_db_restore_job_backup_id" {
  type        = string
  description = "Backup ID for Kani DB Restore Job"
  sensitive   = true
}
