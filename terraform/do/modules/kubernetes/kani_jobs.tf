// =========================
// Kani CLI Job Seed local identifiers
// =========================
// Defines shared names for ConfigMap and Secret created by kani-cli Helm chart.
locals {
  // Shared name for ConfigMap & Secret created by kani-cli Helm chart
  // Contains all runtime environment variables (DB, Kafka, etc.)
  kani_cli_service_env_vars_name = "kani-cli-service-env-vars"
}

// =========================
// Kani CLI Secret data source
// =========================
// Reads the Secret containing sensitive environment variables
// created by the kani-cli Helm chart.
data "kubernetes_secret" "cli" {
  metadata {
    name      = local.kani_cli_service_env_vars_name
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  // Ensure Helm release is created before reading the Secret
  depends_on = [
    helm_release.kani_cli
  ]
}

// =========================
// Kani CLI ConfigMap data source
// =========================
// Reads the ConfigMap containing non-sensitive environment variables
// created by the kani-cli Helm chart.
data "kubernetes_config_map" "cli" {
  metadata {
    name      = local.kani_cli_service_env_vars_name
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  // Ensure Helm release is created before reading the ConfigMap
  depends_on = [
    helm_release.kani_cli
  ]
}