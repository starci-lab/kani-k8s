# =========================
# ServiceAccount for Jenkins Agent
# =========================
resource "kubernetes_service_account" "jenkins_agent" {
  metadata {
    name      = "jenkins-agent"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }
}

# =========================
# Role: allow rollout deployment
# =========================
resource "kubernetes_role" "jenkins_agent_rollout_role" {
  metadata {
    name      = "jenkins-agent-rollout-role"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "patch"]
  }
}

# =========================
# RoleBinding: assign Role to SA jenkins agent
# =========================
resource "kubernetes_role_binding" "jenkins_agent_rollout_binding" {
  metadata {
    name      = "jenkins-agent-rollout-binding"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins_agent.metadata[0].name
    namespace = kubernetes_service_account.jenkins_agent.metadata[0].namespace
  }

  role_ref {
    kind      = "Role"
    name      = kubernetes_role.jenkins_agent_rollout_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}