# // =========================
# // Grafana Helm release
# // =========================
# // Deploys Grafana using the Bitnami OCI Helm chart.
# // All configuration is injected via a Terraform-rendered values file.
# resource "helm_release" "grafana" {
#   name      = local.grafana.name
#   namespace = kubernetes_namespace.grafana.metadata[0].name

#   // Bitnami Grafana chart from Docker Hub OCI registry
#   chart = "oci://registry-1.docker.io/bitnamicharts/grafana"

#   // Render Helm values from template and inject Terraform variables
#   values = [
#     templatefile("${path.module}/yamls/grafana.yaml", {
#       // Admin credentials
#       grafana_user     = var.grafana_user
#       grafana_password = var.grafana_password
#       // Replica count
#       replica_count = var.grafana_replica_count
#       // Grafana server resources
#       request_cpu      = local.grafana.grafana.request_cpu
#       request_memory   = local.grafana.grafana.request_memory
#       limit_cpu        = local.grafana.grafana.limit_cpu
#       limit_memory     = local.grafana.grafana.limit_memory
#       persistence_size = var.grafana_persistence_size
#       // Prometheus datasource
#       prometheus_url                 = "http://${local.kube_prometheus_outputs.server_service.host}:${local.kube_prometheus_outputs.server_service.port}"
#       prometheus_basic_auth_user     = var.prometheus_basic_auth_user
#       prometheus_basic_auth_password = var.prometheus_basic_auth_password
#       // Alertmanager datasource
#       prometheus_alertmanager_url                 = "http://${local.kube_prometheus_outputs.alertmanager_server_service.host}:${local.kube_prometheus_outputs.alertmanager_server_service.port}"
#       prometheus_alertmanager_basic_auth_user     = var.prometheus_alertmanager_basic_auth_user
#       prometheus_alertmanager_basic_auth_password = var.prometheus_alertmanager_basic_auth_password
#       // Loki basic authentication
#       loki_url = "http://${local.loki_monolithic_outputs.gateway_service.host}:${local.loki_monolithic_outputs.gateway_service.port}"
#       loki_basic_auth_user = var.loki_basic_auth_user
#       loki_basic_auth_password = var.loki_basic_auth_password
#       // Node scheduling
#       // Ensures Grafana pods are scheduled onto the primary node pool
#       node_pool_label = var.kubernetes_primary_node_pool_name
#     })
#   ]

#   // Ensure the Grafana namespace exists before installing the chart
#   depends_on = [
#     kubernetes_namespace.grafana,
#     // Prometheus Helm release
#     helm_release.kube_prometheus,
#     // Consul Helm release
#     helm_release.consul,
#     // Loki Helm release
#     helm_release.loki_monolithic,
#   ]
# }
