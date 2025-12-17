# Kubernetes provider
provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.kubernetes.kube_config[0].host
  token = digitalocean_kubernetes_cluster.kubernetes.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.kubernetes.kube_config[0].cluster_ca_certificate
  )
}

# Helm provider
provider "helm" {
  kubernetes {
    host  = digitalocean_kubernetes_cluster.kubernetes.kube_config[0].host
    token = digitalocean_kubernetes_cluster.kubernetes.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.kubernetes.kube_config[0].cluster_ca_certificate
    )
  }
}