# =========================
# ServiceAccount for Jenkins Agent (namespace: jenkins)
# =========================
resource "kubernetes_service_account" "jenkins_agent" {
  metadata {
    name      = "jenkins-agent"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }
}

# ==========================================
# Role: allow jenkins-agent to list / get / patch deployments in kani namespace
# Namespace: kani
# ==========================================
resource "kubernetes_role" "jenkins_agent_kani_deploy_role" {
  metadata {
    name      = "jenkins-agent-deploy-role"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "list", "patch"]
  }
}

# =====================================================
# RoleBinding: bind Role to ServiceAccount jenkins-agent in kani namespace
# =====================================================
resource "kubernetes_role_binding" "jenkins_agent_kani_deploy_binding" {
  metadata {
    name      = "jenkins-agent-deploy-binding"
    namespace = kubernetes_namespace.kani.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins_agent.metadata[0].name
    namespace = kubernetes_service_account.jenkins_agent.metadata[0].namespace
  }

  role_ref {
    kind      = "Role"
    name      = kubernetes_role.jenkins_agent_kani_deploy_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}
