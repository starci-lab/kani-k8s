
# Namespace for MongoDB Sharded
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
  depends_on = [ digitalocean_kubernetes_cluster.kubernetes ]
}

# Cert Manager
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = kubernetes_namespace.cert_manager.metadata[0].name
  create_namespace = true
  chart = "oci://registry-1.docker.io/bitnamicharts/cert-manager"
  values = [
    templatefile(
      "${path.module}/yamls/cert-manager.yaml", {
          # Cert Manager
          cert_manager_request_cpu = var.cert_manager_cert_manager_request_cpu
          cert_manager_request_memory = var.cert_manager_cert_manager_request_memory
          cert_manager_limit_cpu = var.cert_manager_cert_manager_limit_cpu
          cert_manager_limit_memory = var.cert_manager_cert_manager_limit_memory
          # Webhook
          webhook_request_cpu = var.cert_manager_webhook_request_cpu
          webhook_request_memory = var.cert_manager_webhook_request_memory
          webhook_limit_cpu = var.cert_manager_webhook_limit_cpu
          webhook_limit_memory = var.cert_manager_webhook_limit_memory
          # CA Injector
          cainjector_request_cpu = var.cert_manager_cainjector_request_cpu
          cainjector_request_memory = var.cert_manager_cainjector_request_memory
          cainjector_limit_cpu = var.cert_manager_cainjector_limit_cpu
          cainjector_limit_memory = var.cert_manager_cainjector_limit_memory
          # Controller
          controller_request_cpu = var.cert_manager_controller_request_cpu
          controller_request_memory = var.cert_manager_controller_request_memory
          controller_limit_cpu = var.cert_manager_controller_limit_cpu
          controller_limit_memory = var.cert_manager_controller_limit_memory
    })
  ]
  depends_on = [
    kubernetes_namespace.cert_manager
  ]
}