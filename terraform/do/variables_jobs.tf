// =========================
// Kani CLI Restore Job Backup ID variables
// =========================
// Backup ID used to restore the database from a backup.

// Backup ID used by the Kani CLI restore job to identify which database backup to restore
variable "kani_db_restore_job_backup_id" {
  type        = string
  description = "Backup ID for Kani DB Restore Job"
  sensitive   = true
}
