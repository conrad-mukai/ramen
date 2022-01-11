/*
 * # EKS Admin module
 *
 * Module to create an eks-admin user. This user is granted access to the
 * cluster-admin ClusterRole.
 */


# -----------------------------------------------------------------------------
# ServiceAccount
# -----------------------------------------------------------------------------

resource "kubernetes_service_account" "this" {
  metadata {
    name      = "eks-admin"
    namespace = "kube-system"
  }
}


# -----------------------------------------------------------------------------
# ClusterRoleBinding
# -----------------------------------------------------------------------------

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = "eks-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = kubernetes_service_account.this.metadata[0].namespace
  }
}
