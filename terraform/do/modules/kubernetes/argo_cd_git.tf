locals {
  argo_cd_project_name = "kani"
}
// ======================================================
// Argo CD Git Repository Configuration
// ------------------------------------------------------
// Registers a Git repository as the single source of truth
// for GitOps. Argo CD will continuously watch this repository
// and synchronize Kubernetes manifests to the cluster.
// ======================================================
resource "argocd_repository" "kani" {
  // URL of the Git repository containing Kubernetes manifests
  repo = var.argo_cd_git_repo_url
  // Git username used for authentication
  username = var.argo_cd_git_username
  // SSH private key allowing Argo CD to pull the repository securely
  ssh_private_key = var.argo_cd_git_ssh_private_key
  // Insecure mode enabled (acceptable for lab / academic environments)
  insecure = true
  depends_on = [
    digitalocean_kubernetes_cluster.kubernetes,
    helm_release.argo_cd
  ]
}

//
// ======================================================
// Argo CD Project Configuration
// ------------------------------------------------------
// An Argo CD Project defines a security and operational
// boundary for applications, including:
// - Allowed source repositories
// - Allowed destination clusters and namespaces
// - Resource access restrictions
// - Project-level RBAC policies
// ======================================================

resource "argocd_project" "kani" {
  metadata {
    // Project name shown in Argo CD
    name = local.argo_cd_project_name
    // Projects must reside in the Argo CD namespace
    namespace = kubernetes_namespace.argo_cd.metadata[0].name
    // Labels for classification and governance
    labels = {
      acceptance = "true"
    }

    // Annotations describing the business logic and architecture
    annotations = {
      "kanibot.xyz/project"      = "true"
      "kanibot.xyz/description"  = "Automated CLMM liquidity bot with risk-aware exit engine"
      "kanibot.xyz/blockchain"   = "sui,solana"
      "kanibot.xyz/architecture" = "adapter-based, event-driven"
      "kanibot.xyz/managed-by"   = "argocd"
      "kanibot.xyz/environment"  = "production"
    }
  }

  spec {
    // High-level description used for documentation and auditing
    description = "Kani is an automated liquidity management system that operates CLMM positions using ultra-thin ranges, integrating on-chain data, CEX order books, and oracle signals to optimize capital efficiency and manage risk."
    // Namespaces from which applications are allowed to reference manifests
    source_namespaces = [kubernetes_namespace.argo_cd.metadata[0].name]
    // Git repositories allowed for this project
    // Wildcard is acceptable for development or academic use
    source_repos = ["*"]

    // --------------------------------------------------
    // Deployment destination restrictions
    // --------------------------------------------------
    destination {
      // In-cluster Kubernetes API server
      server = "https://kubernetes.default.svc"
      // Applications are restricted to the kani namespace
      namespace = kubernetes_namespace.kani.metadata[0].name
    }

    // --------------------------------------------------
    // Cluster-scoped resource access control
    // --------------------------------------------------
    // Deny all cluster-level resources by default
    cluster_resource_blacklist {
      group = "*"
      kind  = "*"
    }

    // Explicitly allow cluster-level RBAC resources only
    cluster_resource_whitelist {
      group = "rbac.authorization.k8s.io"
      kind  = "ClusterRoleBinding"
    }

    cluster_resource_whitelist {
      group = "rbac.authorization.k8s.io"
      kind  = "ClusterRole"
    }

    // --------------------------------------------------
    // Namespace-scoped resource access control
    // --------------------------------------------------
    // Ingress is explicitly blocked to enforce centralized
    // traffic management (e.g., shared gateway or ingress)
    namespace_resource_blacklist {
      group = "networking.k8s.io"
      kind  = "Ingress"
    }

    // All other namespaced resources are allowed
    namespace_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    // --------------------------------------------------
    // Project-level RBAC roles
    // --------------------------------------------------
    // Operator / DevOps role with elevated permissions
    role {
      name = "testrole"
      policies = [
        // Allow application synchronization and overrides
        "p, proj:${local.argo_cd_project_name}:testrole, applications, override, ${local.argo_cd_project_name}/*, allow",
        "p, proj:${local.argo_cd_project_name}:testrole, applications, sync, ${local.argo_cd_project_name}/*, allow",

        // Allow cluster metadata access
        "p, proj:${local.argo_cd_project_name}:testrole, clusters, get, ${local.argo_cd_project_name}/*, allow",

        // Allow Git repository management
        "p, proj:${local.argo_cd_project_name}:testrole, repositories, create, ${local.argo_cd_project_name}/*, allow",
        "p, proj:${local.argo_cd_project_name}:testrole, repositories, delete, ${local.argo_cd_project_name}/*, allow",
        "p, proj:${local.argo_cd_project_name}:testrole, repositories, update, ${local.argo_cd_project_name}/*, allow",

        // Allow debugging and runtime inspection
        "p, proj:${local.argo_cd_project_name}:testrole, logs, get, ${local.argo_cd_project_name}/*, allow",
        "p, proj:${local.argo_cd_project_name}:testrole, exec, create, ${local.argo_cd_project_name}/*, allow",
      ]
    }

    // Read-only or restricted role
    // Read-only or restricted role
    role {
      name = "anotherrole"
      policies = [
        // Allow read access to applications
        "p, proj:${local.argo_cd_project_name}:anotherrole, applications, get, ${local.argo_cd_project_name}/*, allow",

        // Explicitly deny synchronization
        "p, proj:${local.argo_cd_project_name}:anotherrole, applications, sync, ${local.argo_cd_project_name}/*, deny",
      ]
    }

    // --------------------------------------------------
    // Synchronization windows
    // --------------------------------------------------
    // Allow synchronization only during a controlled time window
    sync_window {
      kind         = "allow"
      applications = ["api-*"]
      clusters     = ["*"]
      namespaces   = ["*"]
      duration     = "3600s"
      schedule     = "10 1 * * *"
      manual_sync  = true
    }

    // Deny synchronization during sensitive periods
    sync_window {
      kind         = "deny"
      applications = ["${local.argo_cd_project_name}/*"]
      clusters     = ["in-cluster"]
      namespaces   = ["${local.argo_cd_project_name}/*"]
      duration     = "12h"
      schedule     = "22 1 5 * *"
      manual_sync  = false
      timezone     = "Europe/London"
    }

    // --------------------------------------------------
    // Git commit signature verification
    // --------------------------------------------------
    // Only commits signed with these GPG keys are trusted
    # signature_keys = [
    #   "4AEE18F83AFDEB23",
    #   "07E34825A909B250"
    # ]
  }

  depends_on = [
    argocd_repository.kani
  ]
}

// =========================
// Argo CD Application configuration
// (Defines an application that Argo CD will monitor and deploy to Kubernetes)
// =========================
resource "argocd_application" "kani_app" {
  metadata {
    // Application name shown in Argo CD UI and CLI
    name = "kani"
    // Namespace where Argo CD is installed
    // This MUST be the Argo CD namespace
    namespace = kubernetes_namespace.argo_cd.metadata[0].name
  }

  spec {
    // Argo CD project this application belongs to
    // Use "default" if you are not separating projects
    project = argocd_project.kani.metadata[0].name
    source {
      // Git repository URL
      // Must match the repository configured in argocd_repository
      repo_url = var.argo_cd_git_repo_url
      // Git branch, tag, or commit SHA to track
      // Every push to this branch will be detected by Argo CD
      target_revision = "main"
      // Path inside the repository that contains:
      // - Kubernetes manifests, OR
      // - Kustomize config, OR
      // - Helm chart
      path = "k8s"
    }

    destination {
      // Kubernetes API server
      // This value means: deploy to the same cluster where Argo CD is running
      server = "https://kubernetes.default.svc"
      // Kubernetes namespace where the application will be deployed
      namespace = kubernetes_namespace.kani.metadata[0].name
    }

    sync_policy {
      // Enable automatic synchronization
      // Argo CD will automatically apply changes from Git
      automated {
        // Automatically delete resources removed from Git
        prune = true
        // Automatically correct drift between Git and the cluster
        self_heal = true
      }
    }

  }
  depends_on = [
    argocd_project.kani
  ]
}
