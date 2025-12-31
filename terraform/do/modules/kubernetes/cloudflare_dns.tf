// =========================
// Cloudflare DNS zone lookup
// =========================
// Retrieves the Cloudflare zone corresponding to the base domain.
// This zone ID is required to manage DNS records via the Cloudflare provider.
data "cloudflare_zone" "zone" {
  name = var.domain_name
}

// =========================
// Public domain names
// =========================
// Constructs fully-qualified domain names (FQDNs) for platform services
// by combining service-specific subdomain prefixes with the base domain.
locals {
  argo_cd_domain_name                = "${var.argo_cd_prefix}.${var.domain_name}"
  prometheus_domain_name              = "${var.prometheus_prefix}.${var.domain_name}"
  prometheus_alertmanager_domain_name = "${var.prometheus_alertmanager_prefix}.${var.domain_name}"
  grafana_domain_name                 = "${var.grafana_prefix}.${var.domain_name}"
  portainer_domain_name               = "${var.portainer_prefix}.${var.domain_name}"
  api_domain_name                     = "${var.api_prefix}.${var.domain_name}"
  jenkins_domain_name                 = "${var.jenkins_prefix}.${var.domain_name}"
  kafka_ui_domain_name                = "${var.kafka_ui_prefix}.${var.domain_name}"
}

// =========================
// Cloudflare DNS records
// =========================
// Creates public A records in Cloudflare that point service domains
// to the external IP address of the NGINX Ingress controller.
//
// Traffic flow:
// Internet → Cloudflare DNS → NGINX Ingress → Kubernetes Services
resource "cloudflare_record" "argo_cd" {
  name    = local.argo_cd_domain_name
  type    = "A"
  content = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id = data.cloudflare_zone.zone.id
}

resource "cloudflare_record" "prometheus" {
  name    = local.prometheus_domain_name
  type    = "A"
  content = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id = data.cloudflare_zone.zone.id
}

resource "cloudflare_record" "prometheus_alertmanager" {
  name    = local.prometheus_alertmanager_domain_name
  type    = "A"
  content = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id = data.cloudflare_zone.zone.id
}

resource "cloudflare_record" "grafana" {
  name    = local.grafana_domain_name
  type    = "A"
  content = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id = data.cloudflare_zone.zone.id
}

resource "cloudflare_record" "portainer" {
  name    = local.portainer_domain_name
  type    = "A"
  content = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id = data.cloudflare_zone.zone.id
}

resource "cloudflare_record" "api" {
  name    = local.api_domain_name
  type    = "A"
  content = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id = data.cloudflare_zone.zone.id
}

resource "cloudflare_record" "jenkins" {
  name    = local.jenkins_domain_name
  type    = "A"
  content = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id = data.cloudflare_zone.zone.id
}

resource "cloudflare_record" "kafka_ui" {
  name    = local.kafka_ui_domain_name
  type    = "A"
  content = data.kubernetes_service.nginx_ingress_controller.status[0].load_balancer[0].ingress[0].ip
  zone_id = data.cloudflare_zone.zone.id
}