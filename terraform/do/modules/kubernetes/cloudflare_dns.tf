# Get the zone id
data "cloudflare_zone" "zone" {
  name = var.base_domain_name
}

# Get the domain name
locals {
  domain_name = var.base_domain_name
}

locals {
    argo_cd_domain_name = "argo-cd.${local.domain_name}"
    prometheus_domain_name = "prometheus.${local.domain_name}"
    api_domain_name = "api.${local.domain_name}"
}

# Create the NS records in Cloudflare for each name server
resource "cloudflare_record" "argo_cd" {
  name     = local.argo_cd_domain_name
  type     = "A"
  content  = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id  = data.cloudflare_zone.zone.id
}

resource "cloudflare_record" "prometheus" {
  name     = local.prometheus_domain_name
  type     = "A"
  content  = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id  = data.cloudflare_zone.zone.id
}

resource "cloudflare_record" "api" {
  name     = local.api_domain_name
  type     = "A"
  content  = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id  = data.cloudflare_zone.zone.id
}
