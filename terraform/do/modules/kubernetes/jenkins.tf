// =========================
// Namespace for Jenkins
// =========================
// Creates a dedicated namespace to isolate Jenkins
// and its related resources from application workloads.
resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
  }

  // Ensure the Kubernetes cluster exists before creating the namespace
  depends_on = [digitalocean_kubernetes_cluster.kubernetes]
}

// =========================
// Jenkins local identifiers
// =========================
// Defines naming conventions shared across Helm, Service lookup,
// and Ingress configuration.
locals {
  // Helm release name for Jenkins
  jenkins_name = "jenkins"

  // Service name exposed by the Jenkins server component
  // (created by the Bitnami Helm chart)
  jenkins_server_service_name = "jenkins"
}

// =========================
// Jenkins Helm release
// =========================
// Deploys Jenkins using the Bitnami OCI Helm chart.
// All configuration is injected via a Terraform-rendered values file.
resource "helm_release" "jenkins" {
  name      = local.jenkins_name
  namespace = kubernetes_namespace.jenkins.metadata[0].name

  // Bitnami Jenkins chart from Docker Hub OCI registry
  chart = "oci://registry-1.docker.io/bitnamicharts/jenkins"

  // Render Helm values from template and inject Terraform variables
  values = [
    templatefile("${path.module}/yamls/jenkins.yaml", {
      // =========================
      // Jenkins authentication
      // =========================
      jenkins_user     = var.jenkins_user
      jenkins_password = var.jenkins_password

      // =========================
      // Jenkins resources
      // =========================
      request_cpu    = local.jenkins.jenkins.request_cpu
      request_memory = local.jenkins.jenkins.request_memory
      limit_cpu      = local.jenkins.jenkins.limit_cpu
      limit_memory   = local.jenkins.jenkins.limit_memory

      // =========================
      // Volume permissions init container resources
      // =========================
      volume_permissions_request_cpu    = local.jenkins.volume_permissions.request_cpu
      volume_permissions_request_memory = local.jenkins.volume_permissions.request_memory
      volume_permissions_limit_cpu      = local.jenkins.volume_permissions.limit_cpu
      volume_permissions_limit_memory   = local.jenkins.volume_permissions.limit_memory

      // =========================
      // Jenkins init groovy scripts
      // =========================
      init_hook_scripts_cm = kubernetes_config_map.jenkins_init_groovy_cm.metadata[0].name
      init_hook_scripts_secret = ""
    })
  ]

  // Ensure the Jenkins namespace exists before installing the chart
  depends_on = [
    kubernetes_namespace.jenkins
  ]
}

// =========================
// Read Jenkins server Service
// =========================
// Fetches the Service created by the Jenkins Helm chart.
// This is used to dynamically retrieve service ports
// for Ingress configuration.
data "kubernetes_service" "jenkins_server" {
  metadata {
    name      = local.jenkins_server_service_name
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }

  depends_on = [helm_release.jenkins]
}

// =========================
// Jenkins service port resolution
// =========================
// Selects the HTTP port (80) if available.
// Falls back to the first declared service port
// to avoid Terraform apply failures if the chart changes.
locals {
  jenkins_server_port = try(
    one([
      for p in data.kubernetes_service.jenkins_server.spec[0].port :
      p.port if p.port == 80
    ]),
    data.kubernetes_service.jenkins_server.spec[0].port[0].port
  )
}

// =========================
// Jenkins Ingress
// =========================
// Exposes Jenkins UI via NGINX Ingress with TLS
// managed by cert-manager and DNS handled by Cloudflare.
resource "kubernetes_ingress_v1" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins.metadata[0].name

    annotations = {
      "cert-manager.io/cluster-issuer"                 = var.cert_manager_cluster_issuer_name
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "acme.cert-manager.io/http01-edit-in-place"      = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = local.jenkins_domain_name
      http {
        path {
          path = "/"
          backend {
            service {
              // Dynamically resolved Jenkins service + port
              name = data.kubernetes_service.jenkins_server.metadata[0].name
              port {
                number = local.jenkins_server_port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.jenkins_domain_name]
      secret_name = "jenkins-tls"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer_letsencrypt_prod,
    cloudflare_record.jenkins,
    helm_release.jenkins
  ]
}
