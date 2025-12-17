# Terraform configuration
terraform {
  required_version = "~> 1.14.2"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
