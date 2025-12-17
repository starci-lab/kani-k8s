data "digitalocean_kubernetes_cluster" "kubernetes" {
  name = digitalocean_kubernetes_cluster.kubernetes.name
}

# Kubernetes provider
provider "kubernetes" {
  host                   = data.digitalocean_kubernetes_cluster.kubernetes.kube_config[0].host
  token                  = data.digitalocean_kubernetes_cluster.kubernetes.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.kubernetes.kube_config[0].cluster_ca_certificate
  )
}

# Helm provider (share same k8s config)
provider "helm" {
  kubernetes {
    host                   = data.digitalocean_kubernetes_cluster.kubernetes.kube_config[0].host
    token                  = data.digitalocean_kubernetes_cluster.kubernetes.kube_config[0].token
    cluster_ca_certificate = base64decode(
      data.digitalocean_kubernetes_cluster.kubernetes.kube_config[0].cluster_ca_certificate
    )
  }
}