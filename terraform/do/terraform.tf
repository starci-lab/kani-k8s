// =========================
// Terraform configuration
// =========================
// Defines Terraform version constraints and required providers
// used to provision and manage infrastructure and Kubernetes resources.
terraform {
  // Specifies the compatible Terraform CLI version
  // to ensure consistent behavior across environments.
  required_version = "~> 1.14.2"
  # cloud {
  #   organization = "Kanibot"
  #   workspaces {
  #     name = "kani-k8s"
  #   }
  # }
  // Declares all Terraform providers required by this project
  // along with their sources and version constraints.
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = ">= 7.0.0"
    }
  }
}