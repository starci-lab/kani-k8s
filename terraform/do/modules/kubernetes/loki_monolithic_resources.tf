# // =========================
# // Loki Monolithic resources
# // =========================
# // Loki monolithic (Grafana chart, SingleBinary) uses the same namespace as Loki:
# // =========================
# // Loki Monolithic Service (data)
# // =========================
# // Used to build the Loki monolithic service address for clients (Grafana, Kani, etc.).
# data "kubernetes_service" "loki_monolithic" {
#   metadata {
#     name      = local.loki_monolithic.services.loki_monolithic.name
#     namespace = kubernetes_namespace.loki.metadata[0].name
#   }
#   depends_on = [helm_release.loki_monolithic]
# }

# // =========================
# // Loki Monolithic Gateway Service (data)
# // =========================
# // Used to build the Loki monolithic gateway service address for clients (Grafana, Kani, etc.).
# data "kubernetes_service" "loki_monolithic_gateway" {
#   metadata {
#     name      = local.loki_monolithic.services.gateway_service.name
#     namespace = kubernetes_namespace.loki.metadata[0].name
#   }
#   depends_on = [helm_release.loki_monolithic]
# }