// =========================
// Cloudflare provider
// =========================
// Used to manage DNS records and other Cloudflare resources
// such as zones, certificates, and security settings.
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

// =========================
// DigitalOcean provider
// =========================
// Used to provision and manage DigitalOcean infrastructure
// including Kubernetes clusters, networking, and related resources.
provider "digitalocean" {
  token = var.digitalocean_token
}