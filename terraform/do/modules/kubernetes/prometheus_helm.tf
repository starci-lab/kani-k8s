// =========================
// Prometheus Helm release
// =========================
// Deploys Prometheus using the Bitnami OCI Helm chart.
// All configuration is injected via a Terraform-rendered values file.
resource "helm_release" "prometheus" {
  name      = local.prometheus.name
  namespace = kubernetes_namespace.prometheus.metadata[0].name

  // Bitnami kube-prometheus chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/kube-prometheus"

  // Render Helm values from template and inject Terraform variables
  values = [
    templatefile("${path.module}/yamls/prometheus.yaml", {
      // Prometheus Operator resources
      operator_request_cpu    = local.prometheus.operator.request_cpu
      operator_request_memory = local.prometheus.operator.request_memory
      operator_limit_cpu      = local.prometheus.operator.limit_cpu
      operator_limit_memory   = local.prometheus.operator.limit_memory
      // Prometheus server resources
      prometheus_request_cpu    = local.prometheus.prometheus.request_cpu
      prometheus_request_memory = local.prometheus.prometheus.request_memory
      prometheus_limit_cpu      = local.prometheus.prometheus.limit_cpu
      prometheus_limit_memory   = local.prometheus.prometheus.limit_memory
      // Prometheus persistence
      prometheus_persistence_size = var.prometheus_persistence_size
      // Thanos sidecar resources
      thanos_request_cpu    = local.prometheus.thanos.request_cpu
      thanos_request_memory = local.prometheus.thanos.request_memory
      thanos_limit_cpu      = local.prometheus.thanos.limit_cpu
      thanos_limit_memory   = local.prometheus.thanos.limit_memory
      // Alertmanager resources
      alertmanager_request_cpu    = local.prometheus.alertmanager.request_cpu
      alertmanager_request_memory = local.prometheus.alertmanager.request_memory
      alertmanager_limit_cpu      = local.prometheus.alertmanager.limit_cpu
      alertmanager_limit_memory   = local.prometheus.alertmanager.limit_memory
      // Alertmanager persistence
      alertmanager_persistence_size = var.alertmanager_persistence_size
      // Blackbox Exporter resources
      blackbox_exporter_request_cpu    = local.prometheus.blackbox_exporter.request_cpu
      blackbox_exporter_request_memory = local.prometheus.blackbox_exporter.request_memory
      blackbox_exporter_limit_cpu      = local.prometheus.blackbox_exporter.limit_cpu
      blackbox_exporter_limit_memory   = local.prometheus.blackbox_exporter.limit_memory
      // Thanos Ruler resources
      thanos_ruler_request_cpu    = local.prometheus.thanos_ruler.request_cpu
      thanos_ruler_request_memory = local.prometheus.thanos_ruler.request_memory
      thanos_ruler_limit_cpu      = local.prometheus.thanos_ruler.limit_cpu
      thanos_ruler_limit_memory   = local.prometheus.thanos_ruler.limit_memory
      // Replica counts
      prometheus_replica_count          = var.prometheus_replica_count
      alertmanager_replica_count        = var.alertmanager_replica_count
      blackbox_exporter_replica_count   = var.blackbox_exporter_replica_count
      thanos_ruler_replica_count        = var.thanos_ruler_replica_count
      // Node scheduling
      node_pool_label = var.kubernetes_primary_node_pool_name
    })
  ]

  // Ensure the Prometheus namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.prometheus
  ]
}
