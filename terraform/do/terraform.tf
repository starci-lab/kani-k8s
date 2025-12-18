// =========================
// Terraform configuration
// =========================
// Defines Terraform version constraints and required providers
// used to provision and manage infrastructure and Kubernetes resources.
terraform {
  // Specifies the compatible Terraform CLI version
  // to ensure consistent behavior across environments.
  required_version = "~> 1.14.2"

  // Declares all Terraform providers required by this project
  // along with their sources and version constraints.
  required_providers {
    // DigitalOcean provider
    // Used to manage DigitalOcean infrastructure resources
    // such as Kubernetes clusters, networking, and compute.
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    // Cloudflare provider
    // Used to manage DNS zones, records, and other Cloudflare services.
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }

    // Helm provider
    // Used to deploy and manage applications on Kubernetes using Helm charts.
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }

    // Kubectl provider
    // Used to apply raw Kubernetes manifests and perform imperative
    // Kubernetes operations not covered by the Kubernetes provider.
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

    // Kubernetes provider
    // Used to manage native Kubernetes resources such as
    // Namespaces, Secrets, ConfigMaps, and Services.
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}