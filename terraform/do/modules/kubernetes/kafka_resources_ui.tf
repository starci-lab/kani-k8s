# // =========================
# // Kafka UI Deployment
# // =========================
# // Runs Kafka UI (Provectus) for monitoring and managing the Kafka cluster.
# // The cluster is deployed separately via Helm above.
# resource "kubernetes_deployment" "kafka_ui" {
#   metadata {
#     name      = "kafka-ui"
#     namespace = kubernetes_namespace.kafka.metadata[0].name

#     labels = {
#       app = "kafka-ui"
#     }
#   }

#   depends_on = [
#     helm_release.kafka
#   ]

#   spec {
#     replicas = 1
#     selector {
#       match_labels = {
#         app = "kafka-ui"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "kafka-ui"
#         }
#       }
#       spec {
#         node_selector = {
#           "doks.digitalocean.com/node-pool" = var.kubernetes_primary_node_pool_name
#         }
#         container {
#           name  = "kafka-ui"
#           image = "provectuslabs/kafka-ui:latest"
#           port {
#             container_port = 8080
#           }
#           env {
#             name  = "KAFKA_CLUSTERS_0_NAME"
#             value = "kafka"
#           }
#           env {
#             name  = "KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS"
#             value = "${local.kafka_outputs.service.host}:${local.kafka_outputs.service.port}"
#           }
#           env {
#             name  = "KAFKA_CLUSTERS_0_PROPERTIES_SECURITY_PROTOCOL"
#             value = "SASL_PLAINTEXT"
#           }
#           env {
#             name  = "KAFKA_CLUSTERS_0_PROPERTIES_SASL_MECHANISM"
#             value = "SCRAM-SHA-256"
#           }
#           env {
#             name  = "KAFKA_CLUSTERS_0_PROPERTIES_SASL_JAAS_CONFIG"
#             value = "org.apache.kafka.common.security.scram.ScramLoginModule required username=\"${var.kafka_sasl_user}\" password=\"${var.kafka_sasl_password}\";"
#           }
#           resources {
#             requests = {
#               cpu    = local.kafka.kafka_ui.request_cpu
#               memory = local.kafka.kafka_ui.request_memory
#             }

#             limits = {
#               cpu    = local.kafka.kafka_ui.limit_cpu
#               memory = local.kafka.kafka_ui.limit_memory
#             }
#           }
#         }
#       }
#     }
#   }
# }

# // =========================
# // Kafka UI Service
# // =========================
# resource "kubernetes_service" "kafka_ui" {
#   metadata {
#     name      = "kafka-ui"
#     namespace = kubernetes_namespace.kafka.metadata[0].name
#   }
#   spec {
#     selector = {
#       app = "kafka-ui"
#     }
#     port {
#       port        = 8080
#       target_port = 8080
#     }
#   }
# }

