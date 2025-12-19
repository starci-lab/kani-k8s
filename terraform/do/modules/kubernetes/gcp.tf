// ======================================================
// GCP Service Account Secret
// ======================================================
// Creates a secret for the GCP service account used by External Secrets.
// ======================================================
resource "kubernetes_secret" "gcp_secret_accessor" {
  metadata {
    name      = "gcp-secret-accessor"
    namespace = kubernetes_namespace.external_secrets.metadata[0].name
  }

  data = {
    "secret-access-credentials" = file("${path.root}/secrets/secret-accessor.json")
  }

  type = "Opaque"
}
