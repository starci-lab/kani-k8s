// =========================
// Read Jenkins server Service
// =========================
// Fetches the Service created by the Jenkins Helm chart.
// This is used to dynamically retrieve service ports
// for Ingress configuration.
# data "kubernetes_service" "jenkins_server" {
#   metadata {
#     name      = local.jenkins.server_service_name
#     namespace = kubernetes_namespace.jenkins.metadata[0].name
#   }
#
#   depends_on = [helm_release.jenkins]
# }

// =========================
// Jenkins Ingress
// =========================
// Exposes Jenkins UI via NGINX Ingress with TLS
// managed by cert-manager and DNS handled by Cloudflare.
# resource "kubernetes_ingress_v1" "jenkins" {
#   metadata {
#     name      = "jenkins"
#     namespace = kubernetes_namespace.jenkins.metadata[0].name
#
#     annotations = {
#       "cert-manager.io/cluster-issuer"                 = var.cert_manager_cluster_issuer_name
#       "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
#       "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
#       "acme.cert-manager.io/http01-edit-in-place"      = "true"
#     }
#   }
#
#   spec {
#     ingress_class_name = "nginx"
#
#     rule {
#       host = local.jenkins_domain_name
#       http {
#         path {
#           path = "/"
#           backend {
#             service {
#               // Dynamically resolved Jenkins service + port
#               name = data.kubernetes_service.jenkins_server.metadata[0].name
#               port {
#                 number = local.jenkins.server_port
#               }
#             }
#           }
#         }
#       }
#     }
#
#     tls {
#       hosts       = [local.jenkins_domain_name]
#       secret_name = "jenkins-tls"
#     }
#   }
#
#   depends_on = [
#     kubectl_manifest.cluster_issuer_letsencrypt_prod,
#     cloudflare_record.jenkins,
#     helm_release.jenkins
#   ]
# }
