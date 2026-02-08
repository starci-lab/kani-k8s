// =========================
// kube-prometheus Helm release
// =========================
// Deploys kube-prometheus using the Bitnami OCI Helm chart.
// All configuration is injected via a Terraform-rendered values file.
resource "helm_release" "prometheus" {
  name      = local.prometheus.name
  namespace = kubernetes_namespace.kube_prometheus.metadata[0].name

  // Bitnami kube-prometheus chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/kube-prometheus"

  // Render Helm values from template and inject Terraform variables
  values = [
    templatefile("${path.module}/yamls/kube-prometheus.yaml", {
      // kube-prometheus Operator resources
      kube_prometheus_operator_request_cpu    = local.prometheus.operator.request_cpu
      kube_prometheus_operator_request_memory = local.prometheus.operator.request_memory
      kube_prometheus_operator_limit_cpu      = local.prometheus.operator.limit_cpu
      kube_prometheus_operator_limit_memory   = local.prometheus.operator.limit_memory
      // kube-prometheus Prometheus server resources
      kube_prometheus_request_cpu    = local.prometheus.prometheus.request_cpu
      kube_prometheus_request_memory = local.prometheus.prometheus.request_memory
      kube_prometheus_limit_cpu      = local.prometheus.prometheus.limit_cpu
      kube_prometheus_limit_memory   = local.prometheus.prometheus.limit_memory
      // kube-prometheus Prometheus persistence
      kube_prometheus_persistence_size = var.kube_prometheus_persistence_size
      // Thanos sidecar resources
      kube_prometheus_thanos_request_cpu    = local.prometheus.thanos.request_cpu
      kube_prometheus_thanos_request_memory = local.prometheus.thanos.request_memory
      kube_prometheus_thanos_limit_cpu      = local.prometheus.thanos.limit_cpu
      kube_prometheus_thanos_limit_memory   = local.prometheus.thanos.limit_memory
      // Alertmanager resources
      kube_prometheus_alertmanager_request_cpu    = local.prometheus.alertmanager.request_cpu
      kube_prometheus_alertmanager_request_memory = local.prometheus.alertmanager.request_memory
      kube_prometheus_alertmanager_limit_cpu      = local.prometheus.alertmanager.limit_cpu
      kube_prometheus_alertmanager_limit_memory   = local.prometheus.alertmanager.limit_memory
      // Alertmanager persistence
      kube_prometheus_alertmanager_persistence_size = var.kube_prometheus_alertmanager_persistence_size
      // Blackbox Exporter resources
      kube_prometheus_blackbox_exporter_request_cpu    = local.prometheus.blackbox_exporter.request_cpu
      kube_prometheus_blackbox_exporter_request_memory = local.prometheus.blackbox_exporter.request_memory
      kube_prometheus_blackbox_exporter_limit_cpu      = local.prometheus.blackbox_exporter.limit_cpu
      kube_prometheus_blackbox_exporter_limit_memory   = local.prometheus.blackbox_exporter.limit_memory
      // Thanos Ruler resources
      kube_prometheus_thanos_ruler_request_cpu    = local.prometheus.thanos_ruler.request_cpu
      kube_prometheus_thanos_ruler_request_memory = local.prometheus.thanos_ruler.request_memory
      kube_prometheus_thanos_ruler_limit_cpu      = local.prometheus.thanos_ruler.limit_cpu
      kube_prometheus_thanos_ruler_limit_memory   = local.prometheus.thanos_ruler.limit_memory
      // Replica counts
      kube_prometheus_replica_count          = var.kube_prometheus_replica_count
      kube_prometheus_alertmanager_replica_count        = var.kube_prometheus_alertmanager_replica_count
      kube_prometheus_blackbox_exporter_replica_count   = var.kube_prometheus_blackbox_exporter_replica_count
      kube_prometheus_thanos_ruler_replica_count        = var.kube_prometheus_thanos_ruler_replica_count
      // Node scheduling
      node_pool_label = var.kubernetes_primary_node_pool_name
    })
  ]

  // Ensure the kube-prometheus namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.kube_prometheus
  ]
}
