# Kani Kubernetes Platform

[![Terraform](https://img.shields.io/badge/terraform-1.14.2+-blue.svg)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/kubernetes-1.29+-blue.svg)](https://kubernetes.io/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

Infrastructure as Code (IaC) project for deploying a production-ready Kubernetes platform on DigitalOcean using Terraform. This project provisions a complete Kubernetes cluster with core services, monitoring, CI/CD, platform tooling, and the Kani application ecosystem.

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
- **Core Data Services**: MongoDB Sharded, Redis Cluster, Apache Kafka, Consul
- **Platform Tooling**: Argo CD (GitOps), Jenkins (CI/CD), Prometheus, Grafana, Loki, Portainer
- **Infrastructure**: NGINX Ingress Controller, cert-manager, Cloudflare DNS, External Secrets Operator
- **Application Services**: Kani Interface, Kani Coordinator, Kani Executor, Kani Observer, Kani CLI
- **GCP Integration**: Secret Manager, Cloud KMS, Google Drive integration

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
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   MongoDB    │  │ Redis       │  │   Kafka      │          │
│  │   Sharded    │  │ Cluster     │  │              │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                  │
│  ┌──────────────┐  ┌──────────────────┐                        │
│  │   Consul     │  │   Management     │                        │
│  │   (Service   │  │                  │                        │
│  │   Discovery) │  │   Portainer      │                        │
│  └──────────────┘  └──────────────────┘                        │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │         Kani Application Services                         │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │   │
│  │  │  Interface   │  │ Coordinator  │  │  Executor   │    │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘    │   │
│  │  ┌──────────────┐  ┌──────────────┐                      │   │
│  │  │  Observer    │  │     CLI      │                      │   │
│  │  └──────────────┘  └──────────────┘                      │   │
│  └──────────────────────────────────────────────────────────┘   │
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
                    GCP Services
                    ├── Secret Manager
                    ├── Cloud KMS
                    └── Google Drive API
```

## ✨ Features

- ✅ **Production-Ready**: All services configured with proper resource limits, persistence, and high availability
- ✅ **GitOps Ready**: Argo CD integration for continuous deployment with Git repository synchronization
- ✅ **CI/CD Pipeline**: Jenkins with Kubernetes integration, webhook support, and pipeline-as-code
- ✅ **Full Observability**: Prometheus metrics, Grafana dashboards, and Loki log aggregation
- ✅ **Service Discovery**: Consul for service mesh and service discovery
- ✅ **Secret Management**: External Secrets Operator with GCP Secret Manager integration
- ✅ **Automatic TLS**: cert-manager with Let's Encrypt for automatic certificate provisioning
- ✅ **Flexible Resource Management**: Preset-based configuration system with override support
- ✅ **Multi-Cloud Support**: GCP integration for secret management and encryption, DigitalOcean for compute
- ✅ **Scalable Architecture**: Configurable node pools and resource presets
- ✅ **Database Management**: Automated backup, restore, and seed jobs for MongoDB
- ✅ **Kani Application Suite**: Complete deployment of Kani microservices (Interface, Coordinator, Executor, Observer, CLI)

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

3. **GCP Project** (for External Secrets, Cloud KMS, Google Drive)
   - Project with Secret Manager API enabled
   - Service accounts with appropriate roles:
     - `roles/secretmanager.secretAccessor` for External Secrets
     - Cloud KMS permissions for encryption/decryption
     - Google Drive API access for user data

4. **Domain Name** managed by Cloudflare

5. **GitHub/Git Repository** (for Argo CD GitOps)
   - SSH private key for repository access

## 🚀 Quick Start

```bash
# 1. Clone the repository
git clone <repository-url>
cd kani-k8s

# 2. Navigate to Terraform directory
cd terraform/do

# 3. Set up environment variables
export TF_VAR_digitalocean_token="your-digitalocean-token"
export TF_VAR_cloudflare_api_token="your-cloudflare-token"

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
export TF_VAR_digitalocean_token="your-digitalocean-token"
export TF_VAR_cloudflare_api_token="your-cloudflare-token"
```

### Step 3: Set Up GCP Service Accounts

The project requires multiple GCP service accounts for different purposes:

#### External Secrets GCP Service Account

Creates a service account for External Secrets Operator to access GCP Secret Manager.

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

#### Crypto Key Encryptor/Decryptor Service Account

Creates a service account for encryption/decryption operations with Cloud KMS.

**Linux/macOS:**
```bash
cd scripts
./create-crypto-key-encryptor-decryptor-sa.sh
```

**Windows:**
```powershell
cd scripts
.\create-crypto-key-encryptor-decryptor-sa.ps1
```

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
kubernetes_version                  = "1.34.1-do.3"
kubernetes_primary_node_pool_name   = "primary-pool"
kubernetes_primary_node_pool_size   = "s-4vcpu-8gb"
kubernetes_primary_node_pool_node_count = 1

# Domain Configuration
domain_name = "example.com"
prefix_domain_name = "dev"

# Feature Flags
enable_redis_cluster = true  # Enable/disable Redis Cluster

# Authentication (use secure methods to provide these)
mongodb_root_password                = "your-mongodb-password"
mongodb_database                     = "kani"
redis_password                      = "your-redis-password"
kafka_sasl_user                     = "kani"
kafka_sasl_password                 = "your-kafka-password"
consul_gossip_key                   = "your-consul-gossip-key"
consul_htpasswd                     = "admin:$apr1$..." # htpasswd format
argo_cd_admin_password             = "$2a$10$..." # bcrypt hash
argo_cd_git_ssh_private_key        = "base64-encoded-ssh-key"
grafana_user                       = "admin"
grafana_password                   = "your-grafana-password"
prometheus_htpasswd                = "admin:$apr1$..." # htpasswd format
prometheus_alertmanager_htpasswd   = "admin:$apr1$..."
prometheus_basic_auth_username     = "admin"
prometheus_basic_auth_password     = "your-password"
prometheus_alertmanager_basic_auth_username = "admin"
prometheus_alertmanager_basic_auth_password = "your-password"
jenkins_user                       = "admin"
jenkins_password                   = "your-jenkins-password"
kafka_ui_htpasswd                  = "admin:$apr1$..." # htpasswd format

# Kani Application Configuration
jwt_salt                            = "your-jwt-salt"
aes_cbc_salt                        = "your-aes-cbc-salt"
kani_interface_deployment_rollout_webhook_token = "webhook-token"
kani_coordinator_deployment_rollout_webhook_token = "webhook-token"
kani_observer_deployment_rollout_webhook_token = "webhook-token"

# GCP Configuration
gcp_project_id                     = "your-gcp-project-id"
gcp_secret_accessor_sa            = "base64-encoded-service-account-json"
gcp_crypto_key_ed_sa               = "base64-encoded-service-account-json"
gcp_cloud_kms_crypto_operator_sa   = "base64-encoded-service-account-json"
gcp_google_drive_ud_sa              = "base64-encoded-service-account-json"
encrypted_aes_key                    = "encrypted-key-from-gcp-kms"
encrypted_jwt_secret_key            = "encrypted-key-from-gcp-kms"
app_secret_version                  = 4
rpcs_secret_version                 = 5

# External API Keys
privy_app_secret_key                = "privy-secret-key"
privy_signer_private_key            = "privy-signer-key"
coin_market_cap_api_key             = "coinmarketcap-api-key"

# Database Jobs
kani_db_restore_job_backup_id       = "backup-id-for-restore"
```

### Variable Organization

The project organizes variables into logical files:

- `variables_kubernetes.tf` - Kubernetes cluster configuration
- `variables_domain.tf` - Domain and DNS configuration
- `variables_authentication.tf` - Authentication credentials for all services
- `variables_keys.tf` - API keys, tokens, and external service credentials
- `variables_enable.tf` - Feature flags and toggles
- `variables_jobs.tf` - Job-specific configuration (backup, restore, seed)
- `variables_mount.tf` - Encrypted secrets and GCP service accounts

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
| **Argo CD** | `https://argo-cd.<prefix>.<domain-name>` | GitOps continuous delivery |
| **Jenkins** | `https://jenkins.<prefix>.<domain-name>` | CI/CD platform |
| **Prometheus** | `https://prometheus.<prefix>.<domain-name>` | Metrics and monitoring |
| **Prometheus Alertmanager** | `https://prometheus-alertmanager.<prefix>.<domain-name>` | Alert management |
| **Grafana** | `https://grafana.<prefix>.<domain-name>` | Metrics visualization |
| **Loki** | `https://loki.<prefix>.<domain-name>` | Log aggregation UI |
| **Portainer** | `https://portainer.<prefix>.<domain-name>` | Kubernetes management UI |
| **Kani Interface** | `https://kani-interface.<prefix>.<domain-name>` | Main application interface |
| **Consul** | `https://consul.<prefix>.<domain-name>` | Service discovery UI |
| **Kafka UI** | `https://kafka-ui.<prefix>.<domain-name>` | Kafka management UI |

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
│           ├── Chart.lock
│           ├── values.yaml
│           └── templates/               # Kubernetes manifests
│               ├── deployment.yaml
│               ├── service.yaml
│               ├── serviceaccount.yaml
│               ├── role.yaml
│               ├── rolebinding.yaml
│               ├── scaledobject.yaml
│               ├── env-vars-configmap.yaml
│               ├── env-vars-secret.yaml
│               └── _helpers.tpl
│
├── scripts/                             # Utility scripts
│   ├── create-external-secrets-gcp-sa.sh     # GCP SA setup (Linux/macOS)
│   ├── create-external-secrets-gcp-sa.ps1    # GCP SA setup (Windows)
│   ├── create-crypto-key-encryptor-decryptor-sa.sh
│   ├── create-crypto-key-encryptor-decryptor-sa.ps1
│   └── misc/                            # Miscellaneous scripts
│
├── terraform/
│   └── do/                              # DigitalOcean Terraform configuration
│       ├── modules/
│       │   └── kubernetes/
│       │       ├── kubernetes_resources.tf        # DOKS cluster definition
│       │       ├── _global_variables_*.tf        # Global variable definitions
│       │       ├── _global_resources_secret_mount.tf
│       │       ├── argo_cd_*.tf                  # Argo CD deployment
│       │       ├── jenkins_*.tf                  # Jenkins CI/CD
│       │       ├── prometheus_*.tf                # Prometheus stack
│       │       ├── grafana_*.tf                  # Grafana deployment
│       │       ├── loki_*.tf                     # Loki log aggregation
│       │       ├── portainer_*.tf                # Portainer deployment
│       │       ├── mongodb_sharded_*.tf          # MongoDB Sharded cluster
│       │       ├── redis_cluster_*.tf            # Redis Cluster
│       │       ├── kafka_*.tf                    # Apache Kafka
│       │       ├── consul_*.tf                   # Consul service discovery
│       │       ├── kani_interface_*.tf            # Kani Interface
│       │       ├── kani_coordinator_*.tf         # Kani Coordinator
│       │       ├── kani_executor_*.tf            # Kani Executor
│       │       ├── kani_observer_*.tf            # Kani Observer
│       │       ├── kani_cli_*.tf                 # Kani CLI
│       │       ├── kani_resources_*.tf           # Kani jobs (backup, restore, seed)
│       │       ├── external_secrets_*.tf         # External Secrets Operator
│       │       ├── nginx_ingress_controller_*.tf
│       │       ├── cert_manager_*.tf
│       │       ├── cloudflare_dns_*.tf
│       │       ├── providers.tf
│       │       ├── terraform.tf
│       │       ├── scripts/                      # Jenkins scripts
│       │       │   └── jenkins/
│       │       │       ├── groovy/
│       │       │       └── jenkinsfiles/
│       │       └── yamls/                        # Helm values templates
│       │           ├── *.yaml
│       │
│       ├── modules.tf                         # Module calls
│       ├── providers.tf                       # Provider configuration
│       ├── terraform.tf                       # Terraform settings
│       ├── variables_authentication.tf        # Authentication secrets
│       ├── variables_domain.tf                 # Domain configuration
│       ├── variables_enable.tf                 # Feature flags
│       ├── variables_jobs.tf                   # Job configuration
│       ├── variables_keys.tf                   # API keys and tokens
│       ├── variables_kubernetes.tf             # Kubernetes variables
│       ├── variables_mount.tf                 # Mount secrets and GCP SAs
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
  - Configurable shard count and replica sets
  - Persistent storage for data durability
  - Root password authentication

- **Redis Cluster**: High-availability Redis cluster with 6 nodes for distributed caching
  - Optional deployment via feature flag
  - Password-protected access
  - Distributed data storage

- **Apache Kafka**: Distributed streaming platform with SASL authentication for event streaming
  - SASL/PLAIN authentication
  - Persistent storage for message retention
  - Kafka UI for management and monitoring

- **Consul**: Service discovery and service mesh
  - Service registration and health checking
  - Key-value store
  - Web UI for service visualization
  - Basic authentication via htpasswd

### Platform Tooling

- **Argo CD**: GitOps continuous delivery tool for Kubernetes applications
  - Git repository synchronization
  - Automated deployments
  - Multi-environment support
  - SSH key authentication for Git repositories

- **Jenkins**: CI/CD platform with Kubernetes integration
  - Kubernetes cloud configuration
  - Generic webhook trigger support
  - Pipeline-as-code with Jenkinsfiles
  - Custom Groovy initialization scripts
  - RBAC for Kubernetes cluster access

- **Prometheus**: Monitoring and alerting system
  - Metrics collection and storage
  - Prometheus Operator for management
  - Alertmanager for alert routing
  - Basic authentication for web UI
  - Long-term storage support (Thanos optional)

- **Grafana**: Metrics visualization and dashboards
  - Pre-configured dashboards
  - Prometheus data source integration
  - Loki data source for logs
  - Alert visualization
  - User authentication

- **Loki**: Log aggregation system
  - Label-based log indexing
  - Grafana integration for log visualization
  - Efficient storage and querying
  - Web UI for log browsing

- **Portainer**: Kubernetes management UI
  - Cluster visualization
  - Resource management
  - User-friendly interface for non-CLI users
  - Container and pod management

### Infrastructure Services

- **NGINX Ingress Controller**: HTTP/HTTPS routing and load balancing
  - SSL/TLS termination
  - Path-based and host-based routing
  - Load balancing algorithms
  - Default backend for unmatched routes

- **cert-manager**: Automatic TLS certificate management
  - Let's Encrypt integration
  - Automatic certificate provisioning and renewal
  - ClusterIssuer and Issuer resources
  - DNS-01 and HTTP-01 challenge support

- **External Secrets Operator**: Secret management integration
  - GCP Secret Manager integration
  - Kubernetes secret synchronization
  - Secure secret rotation
  - Multiple GCP service account support

- **Cloudflare DNS**: DNS record management
  - Automated DNS record creation
  - A and CNAME record management
  - Integration with cert-manager for DNS-01 challenges
  - Subdomain management

### Application Services

- **Kani Interface**: Main application web interface
  - Deployed via Helm charts
  - Configurable via values.yaml
  - Auto-scaling support (KEDA ScaledObject)
  - Webhook-triggered deployment rollouts

- **Kani Coordinator**: Service coordination component
  - Manages service orchestration
  - Webhook-triggered deployment rollouts
  - Configurable resource allocation

- **Kani Executor**: Task execution service
  - Handles job execution
  - Configurable resource allocation
  - Integration with data services

- **Kani Observer**: Monitoring and observation service
  - Observes system state
  - Webhook-triggered deployment rollouts
  - Metrics collection

- **Kani CLI**: Command-line interface service
  - Database management operations
  - Backup and restore capabilities
  - Seed data operations

### Database Management Jobs

- **Database Backup Job**: CronJob for automated MongoDB backups
  - Scheduled backups
  - Configurable backup retention
  - GCP integration for backup storage

- **Database Restore Job**: One-time job for restoring from backups
  - Restore from specific backup ID
  - Manual trigger via Terraform
  - Data validation

- **Database Seed Job**: One-time job for seeding initial data
  - Initial data population
  - Manual trigger via Terraform
  - Idempotent operations

## 📦 Helm Charts

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

Creates a service account for encryption/decryption operations with Cloud KMS.

**Linux/macOS:**
```bash
./scripts/create-crypto-key-encryptor-decryptor-sa.sh
```

**Windows:**
```powershell
.\scripts\create-crypto-key-encryptor-decryptor-sa.ps1
```

This script:
- Creates a GCP service account for Cloud KMS operations
- Grants appropriate Cloud KMS permissions
- Exports the service account key

## 🔧 Resource Management

### Overview

The project implements a sophisticated three-tier resource configuration system:

1. **Preset-based Configuration**: Pre-defined resource presets for common workloads
2. **Component Presets**: Each component maps to a preset size
3. **Variable Override**: Fine-grained control via individual variables

### Preset Configuration

Presets are defined in `_global_variables_resources.tf`:

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

Each component defines which preset to use in its `*_variables.tf` file.

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
  - Consul and Kafka UI use htpasswd authentication
- **Secret Management**: 
  - All sensitive variables are marked as `sensitive = true` in Terraform
  - External Secrets Operator for centralized secret management
  - GCP Secret Manager integration for secure secret storage
  - Cloud KMS for encryption/decryption of sensitive keys
- **Network Security**: 
  - Services exposed via Ingress with TLS
  - Internal service communication within cluster
- **RBAC**: Proper Kubernetes RBAC for service accounts
- **GCP Integration**:
  - Multiple service accounts with least privilege
  - Encrypted keys stored in Cloud KMS
  - Google Drive API access for user data

### Best Practices

1. **Never commit secrets**: Use environment variables, `.tfvars` files (git-ignored), or secret management systems
2. **Rotate credentials**: Regularly rotate passwords and API tokens
3. **Least privilege**: Grant minimal required permissions to service accounts
4. **Audit access**: Regularly review and audit access to sensitive services
5. **Update regularly**: Keep Terraform providers, Kubernetes, and Helm charts updated
6. **Encrypt at rest**: Use GCP Cloud KMS for sensitive encryption keys
7. **Base64 encoding**: Service account JSONs are base64-encoded in variables

## 🐛 Troubleshooting

### Common Issues

#### 1. Terraform apply fails with provider errors

**Solution:**
- Verify API tokens are set correctly (`TF_VAR_digitalocean_token`, `TF_VAR_cloudflare_api_token`)
- Check provider versions match requirements in `terraform.tf`
- Run `terraform init -upgrade` to update providers

#### 2. Services not accessible

**Solution:**
- Verify DNS records are created in Cloudflare: `kubectl get ingress --all-namespaces`
- Check NGINX Ingress Controller is running: `kubectl get pods -n ingress-nginx`
- Verify cert-manager has issued certificates: `kubectl get certificates --all-namespaces`
- Check certificate status: `kubectl describe certificate -n <namespace> <cert-name>`
- Verify domain prefix is correct in DNS records

#### 3. Resource allocation issues

**Solution:**
- Check node pool capacity: `kubectl describe nodes`
- Review resource requests/limits: `kubectl describe pod -n <namespace> <pod-name>`
- Adjust presets in `_global_variables_resources.tf`
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
- Verify GCP service account keys are base64-encoded correctly
- Check External Secrets Operator is running: `kubectl get pods -n external-secrets`
- Verify GCP Secret Manager API is enabled
- Check ExternalSecret status: `kubectl describe externalsecret -n <namespace> <name>`
- Verify service account has correct permissions

#### 6. GCP Cloud KMS decryption fails

**Solution:**
- Verify encrypted keys are correctly formatted
- Check Cloud KMS crypto operator service account permissions
- Verify crypto key exists and is accessible
- Check service account JSON is correctly base64-encoded

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

# Check jobs and cronjobs
kubectl get jobs --all-namespaces
kubectl get cronjobs --all-namespaces

# Check External Secrets
kubectl get externalsecrets --all-namespaces
kubectl describe externalsecret -n <namespace> <name>
```

### Getting Help

1. Check logs: Use `kubectl logs` to view pod logs
2. Describe resources: Use `kubectl describe` to see detailed resource status
3. Review Terraform state: `terraform show` to see current state
4. Check Helm values: Review values in `yamls/` directory
5. Review documentation: See `terraform/do/DEV.md` for resource allocation details

## 📝 Notes

- All Helm charts use Bitnami OCI charts from Docker Hub registry
- Resource presets can be customized in `_global_variables_resources.tf`
- Component-specific presets are defined in each `*_variables.tf` file
- TLS certificates are automatically renewed by cert-manager
- Persistent volumes are created for stateful services (MongoDB, Redis, Kafka, Prometheus, Grafana, Loki, Consul)
- Jenkins uses init scripts for automated configuration
- External Secrets syncs secrets from GCP Secret Manager to Kubernetes secrets
- GCP service account JSONs are base64-encoded in variables for security
- Domain names use prefix pattern: `<service>.<prefix>.<domain-name>`
- Kani services support webhook-triggered deployment rollouts
- Database backup/restore/seed jobs are managed via Terraform

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
- Keep sensitive data out of commits

## 📄 License

[Add your license information here]

## 👥 Contributors

- [starci183](https://x.com/0xstacynguyen) - Maintainer

## 🙏 Acknowledgments

- Bitnami for Helm charts
- DigitalOcean for Kubernetes platform
- Cloudflare for DNS services
- Google Cloud Platform for secret management and encryption services
- All open-source contributors

---

**⚠️ Important**: This is a production-ready infrastructure setup. Always review and test changes in a development environment before applying to production. Ensure you have proper backups and disaster recovery procedures in place.
