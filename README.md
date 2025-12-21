# Kani Kubernetes Platform

[![Terraform](https://img.shields.io/badge/terraform-1.14.2+-blue.svg)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/kubernetes-1.29+-blue.svg)](https://kubernetes.io/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

Infrastructure as Code (IaC) project for deploying a production-ready Kubernetes platform on DigitalOcean using Terraform. This project provisions a complete Kubernetes cluster with core services, monitoring, CI/CD, and platform tooling.

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [Project Structure](#-project-structure)
- [Services](#-services)
- [Helm Charts](#-helm-charts)
- [Scripts](#-scripts)
- [Resource Management](#-resource-management)
- [Security](#-security)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)

## 🎯 Overview

This Terraform project automates the deployment of a comprehensive Kubernetes platform on DigitalOcean, including:

- **Kubernetes Cluster**: DigitalOcean Kubernetes (DOKS) with configurable node pools
- **Core Data Services**: MongoDB Sharded, Redis Cluster, Apache Kafka
- **Platform Tooling**: Argo CD (GitOps), Jenkins (CI/CD), Prometheus, Grafana, Loki, Portainer
- **Infrastructure**: NGINX Ingress Controller, cert-manager, Cloudflare DNS, External Secrets Operator
- **Application Services**: Kani Interface

All services are deployed using Helm charts with configurable resource limits, persistence, and production-ready defaults.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                 DigitalOcean Kubernetes (DOKS)                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────┐  ┌──────────────────┐                    │
│  │   CI/CD Layer    │  │  GitOps Layer    │                    │
│  │                  │  │                  │                    │
│  │   Jenkins        │  │   Argo CD        │                    │
│  └──────────────────┘  └──────────────────┘                    │
│                                                                  │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │  Observability   │  │   Monitoring     │  │   Logging    │ │
│  │                  │  │                  │  │              │ │
│  │   Grafana        │  │   Prometheus     │  │   Loki       │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐ │
│  │   MongoDB    │  │ Redis        │  │      Kafka           │ │
│  │   Sharded    │  │ Cluster      │  │                      │ │
│  └──────────────┘  └──────────────┘  └──────────────────────┘ │
│                                                                  │
│  ┌──────────────────┐  ┌──────────────────┐                    │
│  │   Application    │  │   Management     │                    │
│  │                  │  │                  │                    │
│  │   Kani Interface │  │   Portainer      │                    │
│  └──────────────────┘  └──────────────────┘                    │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │         NGINX Ingress Controller + cert-manager          │   │
│  │              External Secrets Operator                    │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
                    Cloudflare DNS
                            │
                            ▼
                    GCP Secret Manager
                    (External Secrets)
```

## ✨ Features

- ✅ **Production-Ready**: All services configured with proper resource limits, persistence, and high availability
- ✅ **GitOps Ready**: Argo CD integration for continuous deployment
- ✅ **CI/CD Pipeline**: Jenkins with Kubernetes integration and webhook support
- ✅ **Full Observability**: Prometheus metrics, Grafana dashboards, and Loki log aggregation
- ✅ **Secret Management**: External Secrets Operator with GCP Secret Manager integration
- ✅ **Automatic TLS**: cert-manager with Let's Encrypt for automatic certificate provisioning
- ✅ **Flexible Resource Management**: Preset-based configuration system with override support
- ✅ **Multi-Cloud Support**: GCP integration for secret management, DigitalOcean for compute
- ✅ **Scalable Architecture**: Configurable node pools and resource presets

## 📦 Prerequisites

### Required Software

- **Terraform** >= 1.14.2
- **kubectl** (for Kubernetes cluster access)
- **helm** >= 3.0 (for manual chart management)
- **gcloud CLI** (for GCP secret management setup, optional)

### Required Accounts & Tokens

1. **DigitalOcean Account** with API token
   - Create at: https://cloud.digitalocean.com/account/api/tokens
   - Required permissions: Read/Write

2. **Cloudflare Account** with API token
   - Create at: https://dash.cloudflare.com/profile/api-tokens
   - Required permissions: Zone DNS Edit

3. **GCP Project** (for External Secrets, optional)
   - Project with Secret Manager API enabled
   - Service account with `roles/secretmanager.secretAccessor` role

4. **Domain Name** managed by Cloudflare

## 🚀 Quick Start

```bash
# 1. Clone the repository
git clone <repository-url>
cd kani-k8s

# 2. Navigate to Terraform directory
cd terraform/do

# 3. Set up environment variables
export TF_VAR_do_token="your-digitalocean-token"
export TF_VAR_cloudflare_api_token="your-cloudflare-token"
export TF_VAR_cloudflare_email="your-email@example.com"

# 4. Initialize Terraform
terraform init

# 5. Create and configure your environment file
cp env/dev.tfvars env/myenv.tfvars
# Edit env/myenv.tfvars with your configuration

# 6. Plan and apply
terraform plan -var-file=env/myenv.tfvars
terraform apply -var-file=env/myenv.tfvars
```

For detailed setup instructions, see [Installation](#-installation) section.

## 📥 Installation

### Step 1: Clone Repository

```bash
git clone <repository-url>
cd kani-k8s
```

### Step 2: Configure API Tokens

Set the following environment variables or configure them in your `.tfvars` file:

```bash
export TF_VAR_do_token="your-digitalocean-token"
export TF_VAR_cloudflare_api_token="your-cloudflare-token"
export TF_VAR_cloudflare_email="your-email@example.com"
```

### Step 3: Set Up GCP Service Account (Optional)

If using External Secrets with GCP Secret Manager:

**Linux/macOS:**
```bash
cd scripts
./create-external-secrets-gcp-sa.sh
```

**Windows:**
```powershell
cd scripts
.\create-external-secrets-gcp-sa.ps1
```

This will create a service account and export the key to `terraform/do/secrets/external-secrets-gcp-sa.json`.

### Step 4: Initialize Terraform

```bash
cd terraform/do
terraform init
```

### Step 5: Configure Environment

Create or edit `env/dev.tfvars` with your configuration (see [Configuration](#-configuration) section).

## ⚙️ Configuration

### Environment Variables

Create `terraform/do/env/dev.tfvars` or set the following variables:

```hcl
# DigitalOcean Configuration
kubernetes_name                      = "kani-k8s"
kubernetes_region                   = "sgp1"
kubernetes_version                  = "1.29.x-do.0"
kubernetes_primary_node_pool_name   = "primary-pool"
kubernetes_primary_node_pool_size   = "s-2vcpu-4gb"
kubernetes_primary_node_pool_node_count = 2

# Domain Configuration
domain_name = "example.com"

# Feature Flags
enable_redis_cluster = true  # Enable/disable Redis Cluster

# Authentication (use secure methods to provide these)
mongodb_root_password                = "your-mongodb-password"
redis_password                      = "your-redis-password"
kafka_sasl_password                = "your-kafka-password"
argo_cd_admin_password             = "$2a$10$..." # bcrypt hash
grafana_user                       = "admin"
grafana_password                   = "your-grafana-password"
prometheus_htpasswd                = "admin:$apr1$..." # htpasswd format
prometheus_alertmanager_htpasswd   = "admin:$apr1$..."
prometheus_basic_auth_username     = "admin"
prometheus_basic_auth_password     = "your-password"
prometheus_alertmanager_basic_auth_username = "admin"
prometheus_alertmanager_basic_auth_password = "your-password"
jenkins_admin_user                 = "admin"
jenkins_admin_password             = "your-jenkins-password"
```

### Resource Configuration

The project uses a flexible three-tier resource management system:

#### 1. Preset-based Configuration

Resources can be configured using preset sizes: `16`, `32`, `64`, `96`, `128`, `192`, `256`, `384`, `512`, `768`, `1024`, `1536`, `2048`

Example preset mappings:
- `16`: 16m CPU / 32Mi Memory (requests) → 128m CPU / 256Mi Memory (limits)
- `32`: 32m CPU / 64Mi Memory (requests) → 256m CPU / 512Mi Memory (limits)
- `64`: 64m CPU / 128Mi Memory (requests) → 512m CPU / 1024Mi Memory (limits)
- `128`: 128m CPU / 256Mi Memory (requests) → 1024m CPU / 2048Mi Memory (limits)

#### 2. Component Presets

Each component defines which preset to use in its `*_variables.tf` file.

#### 3. Variable Override

Individual resource variables can override presets for fine-grained control.

#### Priority Order

1. **Variable override** (if set)
2. **Preset from resources_config** (if preset exists)
3. **Default value** (fallback)

For detailed resource allocation information, see [`terraform/do/DEV.md`](terraform/do/DEV.md).

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

| Service | URL | Description |
|---------|-----|-------------|
| **Argo CD** | `https://argo-cd.<domain-name>` | GitOps continuous delivery |
| **Jenkins** | `https://jenkins.<domain-name>` | CI/CD platform |
| **Prometheus** | `https://prometheus.<domain-name>` | Metrics and monitoring |
| **Prometheus Alertmanager** | `https://prometheus-alertmanager.<domain-name>` | Alert management |
| **Grafana** | `https://grafana.<domain-name>` | Metrics visualization |
| **Portainer** | `https://portainer.<domain-name>` | Kubernetes management UI |
| **Kani Interface** | `https://kani-interface.<domain-name>` | Application interface |

### Update Configuration

1. Modify variables in `env/dev.tfvars` or variable files
2. Run `terraform plan -var-file=env/dev.tfvars` to preview changes
3. Run `terraform apply -var-file=env/dev.tfvars` to apply changes

### Destroy Infrastructure

```bash
terraform destroy -var-file=env/dev.tfvars
```

⚠️ **Warning**: This will delete all resources including persistent volumes and all data!

## 📁 Project Structure

```
kani-k8s/
├── charts/                              # Helm charts for applications
│   └── repo/
│       └── service/                     # Kani service Helm chart
│           ├── Chart.yaml
│           ├── values.yaml
│           └── templates/               # Kubernetes manifests
│
├── scripts/                             # Utility scripts
│   ├── create-external-secrets-gcp-sa.sh     # GCP SA setup (Linux/macOS)
│   ├── create-external-secrets-gcp-sa.ps1    # GCP SA setup (Windows)
│   ├── create-crypto-key-encryptor-decryptor-sa.sh
│   └── create-crypto-key-encryptor-decryptor-sa.ps1
│
├── terraform/
│   └── do/                              # DigitalOcean Terraform configuration
│       ├── modules/
│       │   └── kubernetes/
│       │       ├── kubernetes.tf              # DOKS cluster definition
│       │       ├── kubernetes_variables.tf    # Cluster configuration
│       │       ├── argo_cd.tf                 # Argo CD deployment
│       │       ├── jenkins.tf                 # Jenkins CI/CD
│       │       ├── prometheus.tf              # Prometheus stack
│       │       ├── grafana.tf                 # Grafana deployment
│       │       ├── loki.tf                    # Loki log aggregation
│       │       ├── portainer.tf               # Portainer deployment
│       │       ├── mongodb_sharded.tf         # MongoDB Sharded cluster
│       │       ├── redis_cluster.tf           # Redis Cluster
│       │       ├── kafka.tf                   # Apache Kafka
│       │       ├── kani_interface.tf          # Kani Interface application
│       │       ├── external_secrets.tf        # External Secrets Operator
│       │       ├── gcp.tf                     # GCP integration
│       │       ├── nginx_ingress_controller.tf
│       │       ├── cert_manager.tf
│       │       ├── cloudflare_dns.tf
│       │       ├── resources_variables.tf     # Resource presets
│       │       ├── scripts/                   # Jenkins scripts
│       │       │   └── jenkins/
│       │       │       ├── groovy/
│       │       │       └── jenkinsfiles/
│       │       └── yamls/                     # Helm values templates
│       │
│       ├── modules.tf                         # Module calls
│       ├── providers.tf                       # Provider configuration
│       ├── terraform.tf                       # Terraform settings
│       ├── authentication_variables.tf        # Authentication secrets
│       ├── domain_variables.tf                # Domain configuration
│       ├── enable_variables.tf                # Feature flags
│       ├── keys_variables.tf                  # API keys
│       ├── kubernetes_variables.tf            # Kubernetes variables
│       ├── DEV.md                             # Resource allocation documentation
│       ├── env/
│       │   └── dev.tfvars                     # Environment-specific values
│       └── secrets/                           # Secret files (git-ignored)
│
└── README.md                                 # This file
```

## 🛠️ Services

### Core Data Services

- **MongoDB Sharded**: Scalable MongoDB cluster with configurable shards, replicasets, and config servers
- **Redis Cluster**: High-availability Redis cluster with 6 nodes for distributed caching
- **Apache Kafka**: Distributed streaming platform with SASL authentication for event streaming

### Platform Tooling

- **Argo CD**: GitOps continuous delivery tool for Kubernetes applications
  - Git repository synchronization
  - Automated deployments
  - Multi-environment support

- **Jenkins**: CI/CD platform with Kubernetes integration
  - Kubernetes cloud configuration
  - Generic webhook trigger support
  - Pipeline-as-code with Jenkinsfiles
  - Custom Groovy initialization scripts

- **Prometheus**: Monitoring and alerting system
  - Metrics collection and storage
  - Prometheus Operator for management
  - Alertmanager for alert routing
  - Thanos for long-term storage (optional)

- **Grafana**: Metrics visualization and dashboards
  - Pre-configured dashboards
  - Prometheus data source integration
  - Alert visualization

- **Loki**: Log aggregation system
  - Label-based log indexing
  - Grafana integration for log visualization
  - Efficient storage and querying

- **Portainer**: Kubernetes management UI
  - Cluster visualization
  - Resource management
  - User-friendly interface for non-CLI users

### Infrastructure Services

- **NGINX Ingress Controller**: HTTP/HTTPS routing and load balancing
  - SSL/TLS termination
  - Path-based and host-based routing
  - Load balancing algorithms

- **cert-manager**: Automatic TLS certificate management
  - Let's Encrypt integration
  - Automatic certificate provisioning and renewal
  - ClusterIssuer and Issuer resources

- **External Secrets Operator**: Secret management integration
  - GCP Secret Manager integration
  - Kubernetes secret synchronization
  - Secure secret rotation

- **Cloudflare DNS**: DNS record management
  - Automated DNS record creation
  - A and CNAME record management
  - Integration with cert-manager for DNS-01 challenges

### Application Services

- **Kani Interface**: Main application interface
  - Deployed via Helm charts
  - Configurable via values.yaml
  - Auto-scaling support (KEDA ScaledObject)

## 📦 Helm Charts

The project includes custom Helm charts for application deployment:

### Service Chart

Located in `charts/repo/service/`, this chart provides:

- **Deployment**: Configurable replica count and update strategies
- **Service**: ClusterIP and LoadBalancer support
- **ConfigMaps & Secrets**: Environment variable management
- **RBAC**: ServiceAccount, Role, and RoleBinding templates
- **Auto-scaling**: KEDA ScaledObject integration
- **Image Management**: Configurable image repositories and tags

#### Usage

```bash
# Install from chart directory
helm install my-service ./charts/repo/service -f values.yaml

# Upgrade existing deployment
helm upgrade my-service ./charts/repo/service -f values.yaml

# Uninstall
helm uninstall my-service
```

See `charts/repo/service/values.yaml` for all configurable options.

## 🔧 Scripts

### GCP Service Account Setup

#### External Secrets GCP Service Account

Creates a GCP service account for External Secrets Operator to access GCP Secret Manager.

**Linux/macOS:**
```bash
./scripts/create-external-secrets-gcp-sa.sh
```

**Windows:**
```powershell
.\scripts\create-external-secrets-gcp-sa.ps1
```

This script:
- Creates a GCP service account (`external-secrets-gcp-sa`)
- Grants `roles/secretmanager.secretAccessor` permission
- Exports the service account key to `terraform/do/secrets/external-secrets-gcp-sa.json`

#### Crypto Key Encryptor/Decryptor Service Account

Creates a service account for encryption/decryption operations.

**Linux/macOS:**
```bash
./scripts/create-crypto-key-encryptor-decryptor-sa.sh
```

**Windows:**
```powershell
.\scripts\create-crypto-key-encryptor-decryptor-sa.ps1
```

## 🔧 Resource Management

### Overview

The project implements a sophisticated three-tier resource configuration system:

1. **Preset-based Configuration**: Pre-defined resource presets for common workloads
2. **Component Presets**: Each component maps to a preset size
3. **Variable Override**: Fine-grained control via individual variables

### Preset Configuration

Presets are defined in `resources_variables.tf`:

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
  # ... more presets up to 2048
}
```

### Component Presets

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

### Variable Override

Override presets for specific resources:

```hcl
variable "prometheus_request_cpu" {
  type        = string
  nullable    = true
  default     = null  # Uses preset if null
}
```

### Resource Allocation Documentation

For detailed resource allocation information and recommendations, see [`terraform/do/DEV.md`](terraform/do/DEV.md).

## 🔐 Security

### Security Features

- **TLS/HTTPS**: All services use TLS/HTTPS with certificates managed by cert-manager
- **Authentication**: 
  - Prometheus and Alertmanager use basic authentication
  - Grafana, Jenkins, and Argo CD have admin authentication
- **Secret Management**: 
  - All sensitive variables are marked as `sensitive = true` in Terraform
  - External Secrets Operator for centralized secret management
  - GCP Secret Manager integration for secure secret storage
- **Network Security**: 
  - Services exposed via Ingress with TLS
  - Internal service communication within cluster
- **RBAC**: Proper Kubernetes RBAC for service accounts

### Best Practices

1. **Never commit secrets**: Use environment variables, `.tfvars` files (git-ignored), or secret management systems
2. **Rotate credentials**: Regularly rotate passwords and API tokens
3. **Least privilege**: Grant minimal required permissions to service accounts
4. **Audit access**: Regularly review and audit access to sensitive services
5. **Update regularly**: Keep Terraform providers, Kubernetes, and Helm charts updated

## 🐛 Troubleshooting

### Common Issues

#### 1. Terraform apply fails with provider errors

**Solution:**
- Verify API tokens are set correctly (`TF_VAR_do_token`, `TF_VAR_cloudflare_api_token`)
- Check provider versions match requirements in `terraform.tf`
- Run `terraform init -upgrade` to update providers

#### 2. Services not accessible

**Solution:**
- Verify DNS records are created in Cloudflare: `kubectl get ingress --all-namespaces`
- Check NGINX Ingress Controller is running: `kubectl get pods -n ingress-nginx`
- Verify cert-manager has issued certificates: `kubectl get certificates --all-namespaces`
- Check certificate status: `kubectl describe certificate -n <namespace> <cert-name>`

#### 3. Resource allocation issues

**Solution:**
- Check node pool capacity: `kubectl describe nodes`
- Review resource requests/limits: `kubectl describe pod -n <namespace> <pod-name>`
- Adjust presets in `resources_variables.tf`
- Scale node pool: Update `kubernetes_primary_node_pool_node_count` in `.tfvars`

#### 4. Helm chart deployment fails

**Solution:**
- Check Kubernetes cluster connectivity: `kubectl cluster-info`
- Verify namespace exists: `kubectl get namespaces`
- Review Helm chart values in `yamls/` directory
- Check Helm release status: `helm list -A`
- View Helm release details: `helm status <release-name> -n <namespace>`

#### 5. External Secrets not working

**Solution:**
- Verify GCP service account key exists: `ls terraform/do/secrets/external-secrets-gcp-sa.json`
- Check External Secrets Operator is running: `kubectl get pods -n external-secrets`
- Verify GCP Secret Manager API is enabled
- Check ExternalSecret status: `kubectl describe externalsecret -n <namespace> <name>`

### Debugging Commands

```bash
# Check Kubernetes cluster status
kubectl cluster-info

# List all namespaces
kubectl get namespaces

# Check pod status across all namespaces
kubectl get pods --all-namespaces

# View pod logs
kubectl logs -n <namespace> <pod-name> --tail=100 -f

# Describe pod for events and status
kubectl describe pod -n <namespace> <pod-name>

# Check ingress status
kubectl get ingress --all-namespaces

# Check certificates
kubectl get certificates --all-namespaces
kubectl describe certificate -n <namespace> <cert-name>

# Check persistent volumes
kubectl get pv
kubectl get pvc --all-namespaces

# Check Helm releases
helm list -A
helm status <release-name> -n <namespace>

# Check service accounts and secrets
kubectl get serviceaccounts --all-namespaces
kubectl get secrets --all-namespaces
```

### Getting Help

1. Check logs: Use `kubectl logs` to view pod logs
2. Describe resources: Use `kubectl describe` to see detailed resource status
3. Review Terraform state: `terraform show` to see current state
4. Check Helm values: Review values in `yamls/` directory
5. Review documentation: See `terraform/do/DEV.md` for resource allocation details

## 📝 Notes

- All Helm charts use Bitnami OCI charts from Docker Hub registry
- Resource presets can be customized in `resources_variables.tf`
- Component-specific presets are defined in each `*_variables.tf` file
- TLS certificates are automatically renewed by cert-manager
- Persistent volumes are created for stateful services (MongoDB, Redis, Kafka, Prometheus, Grafana, Loki)
- Jenkins uses init scripts for automated configuration
- External Secrets syncs secrets from GCP Secret Manager to Kubernetes secrets

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines

- Follow existing code style and conventions
- Add tests for new features when applicable
- Update documentation for any changes
- Ensure Terraform code follows best practices
- Test changes in a development environment before submitting

## 📄 License

[Add your license information here]

## 👥 Contributors

- [starci183](https://x.com/0xstacynguyen) - Maintainer

## 🙏 Acknowledgments

- Bitnami for Helm charts
- DigitalOcean for Kubernetes platform
- Cloudflare for DNS services
- All open-source contributors

---

**⚠️ Important**: This is a production-ready infrastructure setup. Always review and test changes in a development environment before applying to production. Ensure you have proper backups and disaster recovery procedures in place.
