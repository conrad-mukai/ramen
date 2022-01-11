/*
 * # Cluster Autoscaler Module
 *
 * This module deploys a cluster autoscaler. The document used to implement
 * this is:
 *
 * https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html
 */


# -----------------------------------------------------------------------------
# IAM Role
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "cluster_autoscaler_permissions" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name   = "${var.env}-cluster-autoscaler"
  policy = data.aws_iam_policy_document.cluster_autoscaler_permissions.json
}

resource "aws_iam_role" "cluster_autoscaler" {
  name               = "${var.env}-cluster-autoscaler"
  assume_role_policy = var.oidc_assume_policy
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
  role       = aws_iam_role.cluster_autoscaler.name
}


# -----------------------------------------------------------------------------
# ServiceAccount
# -----------------------------------------------------------------------------

resource "kubernetes_service_account" "this" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app   = "cluster-autoscaler"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.cluster_autoscaler.arn
    }
  }
}


# -----------------------------------------------------------------------------
# ClusterRole
# -----------------------------------------------------------------------------

resource "kubernetes_cluster_role" "this" {
  metadata {
    name = "cluster-autoscaler"
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app   = "cluster-autoscaler"
    }
  }
  rule {
    api_groups = [""]
    resources  = ["events", "endpoints"]
    verbs      = ["create", "patch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/eviction"]
    verbs      = ["create"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/status"]
    verbs      = ["update"]
  }
  rule {
    api_groups     = [""]
    resources      = ["endpoints"]
    resource_names = ["cluster-autoscaler"]
    verbs          = ["get", "update"]
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["watch", "list", "get", "update"]
  }
  rule {
    api_groups = [""]
    resources = [
      "namespaces", "pods", "services", "replicationcontrollers",
      "persistentvolumeclaims", "persistentvolumes"
    ]
    verbs = ["watch", "list", "get"]
  }
  rule {
    api_groups = ["extensions"]
    resources  = ["replicasets", "daemonsets"]
    verbs      = ["watch", "list", "get"]
  }
  rule {
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
    verbs      = ["watch", "list"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["statefulsets", "replicasets", "daemonsets"]
    verbs      = ["watch", "list", "get"]
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources = [
      "storageclasses", "csinodes", "csidrivers", "csistoragecapacities"
    ]
    verbs = ["watch", "list", "get"]
  }
  rule {
    api_groups = ["batch", "extensions"]
    resources  = ["jobs"]
    verbs      = ["get", "list", "watch", "patch"]
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create"]
  }
  rule {
    api_groups     = ["coordination.k8s.io"]
    resources      = ["leases"]
    resource_names = ["cluster-autoscaler"]
    verbs          = ["get", "update"]
  }
}


# -----------------------------------------------------------------------------
# Role
# -----------------------------------------------------------------------------

resource "kubernetes_role" "this" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app   = "cluster-autoscaler"
    }
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["create", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    resource_names = [
      "cluster-autoscaler-status", "cluster-autoscaler-priority-expander"
    ]
    verbs = ["delete", "get", "update", "watch"]
  }
}


# -----------------------------------------------------------------------------
# ClusterRoleBinding
# -----------------------------------------------------------------------------

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = "cluster-autoscaler"
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app   = "cluster-autoscaler"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.this.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = kubernetes_service_account.this.metadata[0].namespace
  }
}


# -----------------------------------------------------------------------------
# RoleBinding
# -----------------------------------------------------------------------------

resource "kubernetes_role_binding" "this" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app   = "cluster-autoscaler"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.this.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = kubernetes_service_account.this.metadata[0].name
  }
}


# -----------------------------------------------------------------------------
# Deployment
# -----------------------------------------------------------------------------

resource "kubernetes_deployment" "this" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      app = "cluster-autoscaler"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "cluster-autoscaler"
      }
    }
    template {
      metadata {
        labels = {
          app = "cluster-autoscaler"
        }
        annotations = {
          "prometheus.io/scrape"                           = "true"
          "prometheus.io/port"                             = "8085"
          "cluster-autoscaler.kubernetes.io/safe-to-evict" = "false"
        }
      }
      spec {
        priority_class_name = "system-cluster-critical"
        security_context {
          run_as_non_root = true
          run_as_user     = 65534
          fs_group        = 65534
        }
        service_account_name = kubernetes_service_account.this.metadata[0].name
        container {
          image = "k8s.gcr.io/autoscaling/cluster-autoscaler:${var.image_tag}"
          name  = "cluster-autoscaler"
          resources {
            limits = {
              cpu    = "100m"
              memory = "600Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "600Mi"
            }
          }
          command = [
            "./cluster-autoscaler",
            "--v=4",
            "--stderrthreshold=info",
            "--cloud-provider=aws",
            "--skip-nodes-with-local-storage=false",
            "--expander=least-waste",
            "--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/${var.cluster_name}",
            "--balance-similar-node-groups",
            "--skip-nodes-with-system-pods=false"
          ]
          volume_mount {
            mount_path = "/etc/ssl/certs/ca-certificates.crt"
            name       = "ssl-certs"
          }
          image_pull_policy = "Always"
        }
        node_selector = var.node_selectors
        volume {
          name = "ssl-certs"
          host_path {
            path = "/etc/ssl/certs/ca-bundle.crt"
          }
        }
      }
    }
  }
}
