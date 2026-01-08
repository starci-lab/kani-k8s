
// =========================
// Kubernetes provider
// =========================
// Used to interact directly with the Kubernetes API server
// of the DigitalOcean Kubernetes (DOKS) cluster for managing
// native Kubernetes resources (Namespaces, Secrets, ConfigMaps, etc.).
provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.kubernetes.kube_config[0].host
  token = digitalocean_kubernetes_cluster.kubernetes.kube_config[0].token

  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.kubernetes.kube_config[0].cluster_ca_certificate
  )
}

// =========================
// Helm provider
// =========================
// Used to deploy and manage applications on Kubernetes via Helm charts.
// This provider reuses the same Kubernetes cluster credentials as above
// to install and configure Helm releases.
provider "helm" {
  repository_config_path = "${path.module}/.helm/repositories.yaml" 
  repository_cache       = "${path.module}/.helm"
  kubernetes {
    host  = digitalocean_kubernetes_cluster.kubernetes.kube_config[0].host
    token = digitalocean_kubernetes_cluster.kubernetes.kube_config[0].token

    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.kubernetes.kube_config[0].cluster_ca_certificate
    )
  }
}

// =========================
// Kubectl provider
// =========================
// Used to apply raw Kubernetes manifests and perform imperative
// Kubernetes operations not covered by the Kubernetes provider.
// This provider reuses the same Kubernetes cluster credentials as above
// to apply raw Kubernetes manifests.
provider "kubectl" {
  host                   = digitalocean_kubernetes_cluster.kubernetes.kube_config[0].host
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.kubernetes.kube_config[0].cluster_ca_certificate
    )  # Decodes the certificate authority from the cluster data
  token                  = digitalocean_kubernetes_cluster.kubernetes.kube_config[0].token  # Authentication token for Kubernetes API access
  load_config_file       = false
}

// =========================
// Argo CD provider
// =========================
// Used to interact with the Argo CD API,
// allowing Terraform to manage Argo CD resources such as
// Applications and Projects.
provider "argocd" {
  server_addr = local.argo_cd_domain_name
  username    = "admin"
  password    = var.argo_cd_admin_password
  insecure    = true
}