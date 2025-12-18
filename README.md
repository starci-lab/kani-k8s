# Kani Kubernetes Platform

Infrastructure as Code (IaC) project for deploying a production-ready Kubernetes platform on DigitalOcean using Terraform. This project provisions a complete Kubernetes cluster with core services, monitoring, and platform tooling.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Resource Management](#resource-management)
- [Services](#services)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This Terraform project automates the deployment of:

- **Kubernetes Cluster**: DigitalOcean Kubernetes (DOKS) with configurable node pools
- **Core Services**: MongoDB Sharded, Redis Cluster, Apache Kafka
- **Platform Tooling**: Argo CD, Prometheus, Grafana, Portainer
- **Infrastructure**: NGINX Ingress Controller, cert-manager, Cloudflare DNS

All services are deployed using Helm charts with configurable resource limits and persistence.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    DigitalOcean Kubernetes                   │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Argo CD    │  │  Prometheus  │  │   Grafana    │      │
│  │              │  │              │  │              │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   MongoDB    │  │ Redis Cluster │  │    Kafka    │      │
│  │   Sharded    │  │               │  │             │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│                                                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │         NGINX Ingress Controller + cert-manager      │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                               │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                    Cloudflare DNS
```

## 📦 Prerequisites

- **Terraform** >= 1.14.2
- **kubectl** (for Kubernetes cluster access)
- **helm** (optional, for manual chart management)
- **DigitalOcean Account** with API token
- **Cloudflare Account** with API token
- **Domain Name** managed by Cloudflare

### Required API Tokens

1. **DigitalOcean API Token**
   - Create at: https://cloud.digitalocean.com/account/api/tokens
   - Required permissions: Read/Write

2. **Cloudflare API Token**
   - Create at: https://dash.cloudflare.com/profile/api-tokens
   - Required permissions: Zone DNS Edit

## 🚀 Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd kani-k8s
   ```

2. **Navigate to Terraform directory**
   ```bash
   cd terraform/do
   ```

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Configure environment variables**
   
   Create a `.tfvars` file or set environment variables:
   ```bash
   export TF_VAR_do_token="your-digitalocean-token"
   export TF_VAR_cloudflare_api_token="your-cloudflare-token"
   export TF_VAR_cloudflare_email="your-email@example.com"
   ```

## ⚙️ Configuration

### Environment Variables

Create `terraform/do/env/dev.tfvars` or set the following variables:

```hcl
# DigitalOcean Configuration
kubernetes_name              = "kani-k8s"
kubernetes_region           = "sgp1"
kubernetes_version           = "1.29.x-do.0"
kubernetes_primary_node_pool_name  = "primary-pool"
kubernetes_primary_node_pool_size  = "s-2vcpu-4gb"
kubernetes_primary_node_pool_node_count = 2

# Domain Configuration
domain_name = "example.com"

# Authentication (use secure methods to provide these)
mongodb_root_password        = "your-mongodb-password"
redis_password              = "your-redis-password"
kafka_sasl_password        = "your-kafka-password"
argo_cd_admin_password      = "$2a$10$..." # bcrypt hash
grafana_user               = "admin"
grafana_password           = "your-grafana-password"
prometheus_htpasswd        = "admin:$apr1$..." # htpasswd format
prometheus_alertmanager_htpasswd = "admin:$apr1$..."
prometheus_basic_auth_username   = "admin"
prometheus_basic_auth_password   = "your-password"
prometheus_alertmanager_basic_auth_username = "admin"
prometheus_alertmanager_basic_auth_password = "your-password"
```

### Resource Configuration

The project uses a flexible resource management system with presets:

- **Preset-based configuration**: Resources can be configured using preset sizes (16, 32, 64, 96, 128, 192, 256, 384, 512, 768, 1024, 1536, 2048)
- **Variable override**: Individual resource variables can override presets
- **Default fallback**: If neither preset nor variable is set, defaults are used

Example preset mapping:
- `16`: 16m CPU / 32Mi Memory (requests) → 128m CPU / 256Mi Memory (limits)
- `32`: 32m CPU / 64Mi Memory (requests) → 256m CPU / 512Mi Memory (limits)
- `64`: 64m CPU / 128Mi Memory (requests) → 512m CPU / 1024Mi Memory (limits)

## 📖 Usage

### Deploy Infrastructure

```bash
# Plan the deployment
terraform plan -var-file=env/dev.tfvars

# Apply the configuration
terraform apply -var-file=env/dev.tfvars
```

### Access Services

After deployment, services are accessible via:

- **Argo CD**: `https://argo-cd.<domain-name>`
- **Prometheus**: `https://prometheus.<domain-name>`
- **Prometheus Alertmanager**: `https://prometheus-alertmanager.<domain-name>`
- **Grafana**: `https://grafana.<domain-name>`
- **Portainer**: `https://portainer.<domain-name>`

### Update Configuration

1. Modify variables in `env/dev.tfvars` or variable files
2. Run `terraform plan` to preview changes
3. Run `terraform apply` to apply changes

### Destroy Infrastructure

```bash
terraform destroy -var-file=env/dev.tfvars
```

⚠️ **Warning**: This will delete all resources including persistent volumes!

## 📁 Project Structure

```
terraform/do/
├── modules/
│   └── kubernetes/
│       ├── kubernetes.tf              # DOKS cluster definition
│       ├── kubernetes_variables.tf    # Cluster configuration
│       ├── argo_cd.tf                 # Argo CD deployment
│       ├── argo_cd_variables.tf       # Argo CD configuration
│       ├── prometheus.tf              # Prometheus stack
│       ├── prometheus_variables.tf     # Prometheus configuration
│       ├── grafana.tf                 # Grafana deployment
│       ├── grafana_variables.tf       # Grafana configuration
│       ├── portainer.tf               # Portainer deployment
│       ├── portainer_variables.tf     # Portainer configuration
│       ├── mongodb_sharded.tf         # MongoDB Sharded cluster
│       ├── mongodb_sharded_variables.tf
│       ├── redis_cluster.tf           # Redis Cluster
│       ├── redis_cluster_variables.tf
│       ├── kafka.tf                   # Apache Kafka
│       ├── kafka_variables.tf
│       ├── nginx_ingress_controller.tf # NGINX Ingress
│       ├── nginx_ingress_controller_variables.tf
│       ├── cert_manager.tf             # cert-manager
│       ├── cert_manager_variables.tf
│       ├── cloudflare_dns.tf          # Cloudflare DNS records
│       ├── cloudflare_dns_variables.tf
│       ├── resources_variables.tf     # Resource presets
│       └── yamls/                     # Helm values templates
│           ├── argo-cd.yaml
│           ├── prometheus.yaml
│           ├── grafana.yaml
│           ├── mongodb-sharded.yaml
│           ├── redis-cluster.yaml
│           ├── kafka.yaml
│           └── ...
├── modules.tf                         # Module calls
├── providers.tf                       # Provider configuration
├── terraform.tf                       # Terraform settings
├── authentication_variables.tf        # Authentication secrets
├── domain_variables.tf                # Domain configuration
├── enable_variables.tf                # Feature flags
├── keys_variables.tf                  # API keys
├── kubernetes_variables.tf            # Kubernetes variables
└── env/
    └── dev.tfvars                     # Environment-specific values
```

## 🔧 Resource Management

The project implements a three-tier resource configuration system:

### 1. Preset-based Configuration

Resources are configured using presets defined in `resources_variables.tf`:

```hcl
resources_config = {
  "32" = {
    requests = { cpu = "32m", memory = "64Mi" }
    limits   = { cpu = "256m", memory = "512Mi" }
  }
  "64" = {
    requests = { cpu = "64m", memory = "128Mi" }
    limits   = { cpu = "512m", memory = "1024Mi" }
  }
  # ... more presets
}
```

### 2. Component Presets

Each component defines which preset to use:

```hcl
locals {
  prometheus_presets = {
    operator          = "32"
    prometheus        = "64"
    thanos            = "32"
    alertmanager      = "32"
    blackbox_exporter = "16"
    thanos_ruler      = "32"
  }
}
```

### 3. Variable Override

Individual resource variables can override presets:

```hcl
variable "prometheus_request_cpu" {
  type        = string
  nullable    = true
  default     = null  # Uses preset if null
}
```

### Priority Order

1. **Variable override** (if set)
2. **Preset from resources_config** (if preset exists)
3. **Default value** (fallback)

## 🛠️ Services

### Core Services

- **MongoDB Sharded**: Scalable MongoDB cluster with configurable shards
- **Redis Cluster**: High-availability Redis cluster
- **Apache Kafka**: Distributed streaming platform with SASL authentication

### Platform Tooling

- **Argo CD**: GitOps continuous delivery tool
- **Prometheus**: Monitoring and alerting system
- **Grafana**: Metrics visualization and dashboards
- **Portainer**: Kubernetes management UI

### Infrastructure

- **NGINX Ingress Controller**: HTTP/HTTPS routing and load balancing
- **cert-manager**: Automatic TLS certificate management (Let's Encrypt)
- **Cloudflare DNS**: DNS record management

## 🔐 Security

- All services use TLS/HTTPS with certificates managed by cert-manager
- Prometheus and Alertmanager use basic authentication
- All sensitive variables are marked as `sensitive = true`
- Passwords should be provided via secure methods (environment variables, secret management)

## 🐛 Troubleshooting

### Common Issues

1. **Terraform apply fails with provider errors**
   - Verify API tokens are set correctly
   - Check provider versions match requirements

2. **Services not accessible**
   - Verify DNS records are created in Cloudflare
   - Check NGINX Ingress Controller is running
   - Verify cert-manager has issued certificates

3. **Resource allocation issues**
   - Check node pool capacity
   - Review resource requests/limits
   - Adjust presets in `resources_variables.tf`

4. **Helm chart deployment fails**
   - Check Kubernetes cluster connectivity
   - Verify namespace exists
   - Review Helm chart values in `yamls/` directory

### Debugging

```bash
# Check Kubernetes cluster status
kubectl cluster-info

# List all namespaces
kubectl get namespaces

# Check pod status
kubectl get pods --all-namespaces

# View logs
kubectl logs -n <namespace> <pod-name>

# Check ingress status
kubectl get ingress --all-namespaces
```

## 📝 Notes

- All Helm charts use Bitnami OCI charts from Docker Hub
- Resource presets can be customized in `resources_variables.tf`
- Component-specific presets are defined in each `*_variables.tf` file
- TLS certificates are automatically renewed by cert-manager
- Persistent volumes are created for stateful services

## 📄 License

[Add your license information here]

## 👥 Contributors

[Add contributor information here]

---

**Note**: This is a production-ready infrastructure setup. Always review and test changes in a development environment before applying to production.

