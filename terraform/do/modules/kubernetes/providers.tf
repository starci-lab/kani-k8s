
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
  kubernetes {
    host  = digitalocean_kubernetes_cluster.kubernetes.kube_config[0].host
    token = digitalocean_kubernetes_cluster.kubernetes.kube_config[0].token

    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.kubernetes.kube_config[0].cluster_ca_certificate
    )
  }
}