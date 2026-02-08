// =========================
// Namespace for Consul
// =========================
// Creates a dedicated namespace for HashiCorp Consul resources.
resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// Consul Service (data)
// =========================
// Fetches the Service created by the Consul Helm chart.
data "kubernetes_service" "consul_ui" {
  metadata {
    name      = local.consul.services.ui_service.name
    namespace = kubernetes_namespace.consul.metadata[0].name
  }

  depends_on = [helm_release.consul]
}

// =========================
// Read Consul metrics Service
// =========================
// Fetches the Service created by the Consul Helm chart.
// This is used to dynamically retrieve service ports for Ingress configuration.
data "kubernetes_service" "consul_metrics" {
  metadata {
    name      = local.consul.services.metrics_service.name
    namespace = kubernetes_namespace.consul.metadata[0].name
  }

  depends_on = [helm_release.consul]
}

// =========================
// Read Consul headless Service
// =========================
// Fetches the Service created by the Consul Helm chart.
// This is used to dynamically retrieve service ports for Ingress configuration.
data "kubernetes_service" "consul_headless" {
  metadata {
    name      = local.consul.services.headless_service.name
    namespace = kubernetes_namespace.consul.metadata[0].name
  }

  depends_on = [helm_release.consul]
}