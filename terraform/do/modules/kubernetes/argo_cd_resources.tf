// =========================
// NOTE: This file is currently disabled (commented out)
// =========================
// The resources in this file are commented out and not active.
// Uncomment when ready to deploy Argo CD resources.

// =========================
// Namespace for Argo CD
// =========================
// Creates a dedicated namespace for Argo CD components and resources.
// Argo CD is a declarative GitOps continuous delivery tool for Kubernetes.
# resource "kubernetes_namespace" "argo_cd" {
#   metadata {
#     name = "argo-cd"
#   }
#
#   // Ensure the cluster exists before creating the namespace
#   depends_on = [digitalocean_kubernetes_cluster.kubernetes]
# }

// =========================
// Argo CD Redis Service (data)
// =========================
// Data source to retrieve the Redis service endpoint for Argo CD.
# data "kubernetes_service" "argo_cd_redis" {
#   metadata {
#     name      = "argo-cd-redis-master"
#     namespace = kubernetes_namespace.argo_cd.metadata[0].name
#   }
#
#   depends_on = [
#     helm_release.argo_cd_redis
#   ]
# }

// =========================
// Argo CD server Service (data)
// =========================
// Data source to retrieve the Argo CD server service for Ingress configuration.
# data "kubernetes_service" "argo_cd_server" {
#   metadata {
#     name      = local.argo_cd_server_service_name
#     namespace = kubernetes_namespace.argo_cd.metadata[0].name
#   }
#
#   depends_on = [helm_release.argo_cd]
# }

// =========================
// Argo CD server port (for Ingress)
// =========================
// Computes the Argo CD server port from the service specification.
# locals {
#   argo_cd_server_port = try(
#     one([
#       for p in data.kubernetes_service.argo_cd_server.spec[0].port :
#       p.port if p.port == 80
#     ]),
#     data.kubernetes_service.argo_cd_server.spec[0].port[0].port
#   )
# }

// =========================
// Argo CD Ingress (NGINX + TLS)
// =========================
// Creates an Ingress resource for Argo CD with TLS termination via cert-manager.
// Argo CD server is exposed via NGINX Ingress Controller with automatic TLS certificate issuance.
# resource "kubernetes_ingress_v1" "argo_cd" {
#   metadata {
#     name      = "argo-cd"
#     namespace = kubernetes_namespace.argo_cd.metadata[0].name
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
#       host = local.argo_cd_domain_name
#
#       http {
#         path {
#           path = "/"
#
#           backend {
#             service {
#               name = data.kubernetes_service.argo_cd_server.metadata[0].name
#               port {
#                 number = local.argo_cd_server_port
#               }
#             }
#           }
#         }
#       }
#     }
#
#     tls {
#       hosts       = [local.argo_cd_domain_name]
#       secret_name = "argo-cd-tls"
#     }
#   }
#
#   depends_on = [
#     kubectl_manifest.cluster_issuer_letsencrypt_prod,
#     cloudflare_record.argo_cd,
#     helm_release.argo_cd
#   ]
# }
