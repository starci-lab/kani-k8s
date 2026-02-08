// =========================
// Namespace for Kani
// =========================
// Creates a dedicated namespace for Kani resources.
resource "kubernetes_namespace" "kani" {
  metadata {
    name = "kani"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// Kani CLI Secret data source
// =========================
// Reads the Secret containing sensitive environment variables
// created by the kani-cli Helm chart.
data "kubernetes_secret" "cli" {
  metadata {
    name      = local.kani_cli.service_env_vars_name
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
    name      = local.kani_cli.service_env_vars_name
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  // Ensure Helm release is created before reading the ConfigMap
  depends_on = [
    helm_release.kani_cli
  ]
}
