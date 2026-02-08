// =========================
// Namespace for cert-manager
// =========================
// Creates a dedicated namespace for cert-manager components and resources.
// cert-manager is a Kubernetes add-on to automate the management and issuance of TLS certificates.
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace.
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// cert-manager ClusterIssuer (Let's Encrypt - Production)
// =========================
// Creates a ClusterIssuer used by cert-manager to request TLS certificates
// from Let's Encrypt using the HTTP-01 challenge via NGINX Ingress.
// ClusterIssuer is a cluster-scoped resource that can be referenced by Certificate resources
// across all namespaces to issue certificates from the ACME server.
resource "kubectl_manifest" "cluster_issuer_letsencrypt_prod" {
  // Ensure cert-manager is fully installed before creating the ClusterIssuer
  depends_on = [helm_release.cert_manager]
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ${var.cert_manager_cluster_issuer_name}
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: ${var.cert_manager_email}
    privateKeySecretRef:
      name: ${var.cert_manager_cluster_issuer_name}
    solvers:
      - http01:
          ingress:
            class: nginx
YAML
}
