/*
 * # Metrics Server
 *
 * Deploy a Kubernetes metrics-server. This module is based on:
 *
 * https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html
 */


# -----------------------------------------------------------------------------
# ServiceAccount
# -----------------------------------------------------------------------------

resource "kubernetes_service_account" "this" {
  metadata {
    name      = "metrics-server"
    namespace = "kube-system"
    labels = {
      k8s-app = "metrics-server"
    }
  }
}


# -----------------------------------------------------------------------------
# ClusterRoles
# -----------------------------------------------------------------------------

resource "kubernetes_cluster_role" "aggregated_metrics_reader" {
  metadata {
    name = "system:aggregated-metrics-reader"
    labels = {
      k8s-app                                        = "metrics-server"
      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
      "rbac.authorization.k8s.io/aggregate-to-edit"  = "true"
      "rbac.authorization.k8s.io/aggregate-to-view"  = "true"
    }
  }
  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role" "metrics_server" {
  metadata {
    name = "system:metrics-server"
    labels = {
      k8s-app = "metrics-server"
    }
  }
  rule {
    api_groups = [""]
    resources  = ["pods", "nodes", "nodes/stats", "namespaces", "configmaps"]
    verbs      = ["get", "list", "watch"]
  }
}


# -----------------------------------------------------------------------------
# RoleBinding
# -----------------------------------------------------------------------------

resource "kubernetes_role_binding" "this" {
  metadata {
    name      = "metrics-server-auth-reader"
    namespace = "kube-system"
    labels = {
      k8s-app = "metrics-server"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "extension-apiserver-authentication-reader"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = kubernetes_service_account.this.metadata[0].namespace
  }
}


# -----------------------------------------------------------------------------
# Cluster Role Bindings
# -----------------------------------------------------------------------------

resource "kubernetes_cluster_role_binding" "auth_delegator" {
  metadata {
    name = "metrics-server:system:auth-delegator"
    labels = {
      k8s-app = "metrics-server"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = kubernetes_service_account.this.metadata[0].namespace
  }
}

resource "kubernetes_cluster_role_binding" "metrics_server" {
  metadata {
    name = "system:metrics-server"
    labels = {
      k8s-app = "metrics-server"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.metrics_server.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = kubernetes_service_account.this.metadata[0].namespace
  }
}


# -----------------------------------------------------------------------------
# Service
# -----------------------------------------------------------------------------

resource "kubernetes_service" "this" {
  metadata {
    name      = "metrics-server"
    namespace = "kube-system"
    labels = {
      k8s-app = "metrics-server"
    }
  }
  spec {
    type = "ClusterIP"
    port {
      name        = "https"
      port        = 443
      protocol    = "TCP"
      target_port = "https"
    }
    selector = {
      k8s-app = "metrics-server"
    }
    session_affinity = "None"
  }
}


# -----------------------------------------------------------------------------
# Deployment
# -----------------------------------------------------------------------------

resource "kubernetes_deployment" "this" {
  metadata {
    name      = "metrics-server"
    namespace = "kube-system"
    labels = {
      k8s-app = "metrics-server"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        k8s-app = "metrics-server"
      }
    }
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = "25%"
        max_unavailable = 0
      }
    }
    template {
      metadata {
        labels = {
          k8s-app = "metrics-server"
        }
      }
      spec {
        service_account_name = kubernetes_service_account.this.metadata[0].name
        container {
          name              = "metrics-server"
          image             = "k8s.gcr.io/metrics-server/metrics-server:${var.image_tag}"
          image_pull_policy = "IfNotPresent"
          args = [
            "--cert-dir=/tmp",
            "--secure-port=4443",
            "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
            "--kubelet-use-node-status-port",
            "--metric-resolution=15s"
          ]
          resources {
            requests = {
              cpu    = "100m"
              memory = "200Mi"
            }
          }
          port {
            name           = "https"
            container_port = 4443
            protocol       = "TCP"
          }
          volume_mount {
            mount_path = "/tmp"
            name       = "tmp-dir"
          }
          liveness_probe {
            failure_threshold = 3
            http_get {
              path   = "/livez"
              port   = "https"
              scheme = "HTTPS"
            }
            period_seconds    = 3
            success_threshold = 1
            timeout_seconds   = 1
          }
          readiness_probe {
            failure_threshold = 3
            http_get {
              path   = "/readyz"
              port   = "https"
              scheme = "HTTPS"
            }
            initial_delay_seconds = 20
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
          }
          security_context {
            read_only_root_filesystem = true
            run_as_non_root           = true
            run_as_user               = 1000
          }
          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
        }
        volume {
          name = "tmp-dir"
          empty_dir {}
        }
        node_selector                    = var.node_selectors
        dns_policy                       = "ClusterFirst"
        priority_class_name              = "system-cluster-critical"
        restart_policy                   = "Always"
        termination_grace_period_seconds = 30
      }
    }
  }
}


# -----------------------------------------------------------------------------
# APIService
# -----------------------------------------------------------------------------

resource "kubernetes_api_service" "metrics" {
  metadata {
    name = "v1beta1.metrics.k8s.io"
  }
  spec {
    group                    = "metrics.k8s.io"
    group_priority_minimum   = 100
    version                  = "v1beta1"
    version_priority         = 100
    insecure_skip_tls_verify = true
    service {
      name      = kubernetes_service.this.metadata[0].name
      namespace = kubernetes_service.this.metadata[0].namespace
      port      = kubernetes_service.this.spec[0].port[0].port
    }
  }
}
