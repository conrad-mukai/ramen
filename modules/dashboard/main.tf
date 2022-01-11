/*
 * # Kubernetes Dashboard
 *
 * This module deploys a Kubernetes dashboard. The deployment is based upon:
 *
 * https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html
 * https://aws.amazon.com/premiumsupport/knowledge-center/eks-kubernetes-dashboard-custom-path/
 */


# -----------------------------------------------------------------------------
# Namespace
# -----------------------------------------------------------------------------

resource "kubernetes_namespace" "this" {
  metadata {
    name = "kubernetes-dashboard"
    labels = {
      "kubernetes.io/metadata.name" = "kubernetes-dashboard"
    }
  }
}


# -----------------------------------------------------------------------------
# ServiceAccount
# -----------------------------------------------------------------------------

resource "kubernetes_service_account" "this" {
  metadata {
    name      = "kubernetes-dashboard"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      k8s-app = "kubernetes-dashboard"
    }
  }
}


# -----------------------------------------------------------------------------
# Service
# -----------------------------------------------------------------------------

resource "kubernetes_service" "this" {
  metadata {
    name      = "kubernetes-dashboard"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      k8s-app = "kubernetes-dashboard"
    }
  }
  spec {
    type = "ClusterIP"
    port {
      port        = 443
      protocol    = "TCP"
      target_port = 8443
    }
    selector = {
      k8s-app = "kubernetes-dashboard"
    }
    session_affinity = "None"
  }
}


# -----------------------------------------------------------------------------
# Secrets
# -----------------------------------------------------------------------------

resource "kubernetes_secret" "certs" {
  metadata {
    name      = "kubernetes-dashboard-certs"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      k8s-app = "kubernetes-dashboard"
    }
  }
  type = "Opaque"
}

resource "kubernetes_secret" "csrf" {
  metadata {
    name      = "kubernetes-dashboard-csrf"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      k8s-app = "kubernetes-dashboard"
    }
  }
  type = "Opaque"
  data = {
    csrf = ""
  }
}

resource "kubernetes_secret" "key_holder" {
  metadata {
    name      = "kubernetes-dashboard-key-holder"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      k8s-app = "kubernetes-dashboard"
    }
  }
  type = "Opaque"
}


# -----------------------------------------------------------------------------
# ConfigMap
# -----------------------------------------------------------------------------

resource "kubernetes_config_map" "settings" {
  metadata {
    name      = "kubernetes-dashboard-settings"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      k8s-app = "kubernetes-dashboard"
    }
  }
}


# -----------------------------------------------------------------------------
# Role
# -----------------------------------------------------------------------------

resource "kubernetes_role" "this" {
  metadata {
    name      = "kubernetes-dashboard"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      k8s-app = "kubernetes-dashboard"
    }
  }
  rule {
    api_groups = [""]
    resources  = ["secrets"]
    resource_names = [
      kubernetes_secret.key_holder.metadata[0].name,
      kubernetes_secret.certs.metadata[0].name,
      kubernetes_secret.csrf.metadata[0].name
    ]
    verbs = ["get", "update", "delete"]
  }
  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = [kubernetes_config_map.settings.metadata[0].name]
    verbs          = ["get", "update"]
  }
  rule {
    api_groups = [""]
    resources  = ["services"]
    resource_names = [
      "heapster",
      kubernetes_service.metrics_scraper.metadata[0].name
    ]
    verbs = ["proxy"]
  }
  rule {
    api_groups = [""]
    resources  = ["services/proxy"]
    resource_names = [
      "heapster",
      "http:heapster:",
      "https:heapster:",
      kubernetes_service.metrics_scraper.metadata[0].name,
      "http:${kubernetes_service.metrics_scraper.metadata[0].name}"
    ]
    verbs = ["get"]
  }
}


# -----------------------------------------------------------------------------
# ClusterRole
# -----------------------------------------------------------------------------

resource "kubernetes_cluster_role" "this" {
  metadata {
    name = "kubernetes-dashboard"
    labels = {
      k8s-app = "kubernetes-dashboard"
    }
  }
  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
}


# -----------------------------------------------------------------------------
# RoleBinding
# -----------------------------------------------------------------------------

resource "kubernetes_role_binding" "this" {
  metadata {
    name      = "kubernetes-dashboard"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      k8s-app = "kubernetes-dashboard"
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
    namespace = kubernetes_service_account.this.metadata[0].namespace
  }
}


# -----------------------------------------------------------------------------
# ClusterRoleBinding
# -----------------------------------------------------------------------------

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = "kubernetes-dashboard"
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
# Deployment
# -----------------------------------------------------------------------------

resource "kubernetes_deployment" "this" {
  metadata {
    name      = "kubernetes-dashboard"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  spec {
    replicas               = 1
    revision_history_limit = 10
    selector {
      match_labels = {
        k8s-app = "kubernetes-dashboard"
      }
    }
    template {
      metadata {
        labels = {
          k8s-app = "kubernetes-dashboard"
        }
      }
      spec {
        container {
          name = "kubernetes-dashboard"
          args = [
            "--auto-generate-certificates",
            "--namespace=${kubernetes_namespace.this.metadata[0].name}"
          ]
          image             = "kubernetesui/dashboard:${var.dashboard_image_tag}"
          image_pull_policy = "Always"
          port {
            container_port = 8443
            protocol       = "TCP"
          }
          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
            run_as_group               = 2001
            run_as_user                = 1001
          }
          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          volume_mount {
            mount_path = "/certs"
            name       = "kubernetes-dashboard-certs"
          }
          volume_mount {
            mount_path = "/tmp"
            name       = "tmp-volume"
          }
          liveness_probe {
            http_get {
              path   = "/"
              port   = 8443
              scheme = "HTTPS"
            }
            initial_delay_seconds = 30
            timeout_seconds       = 30
          }
        }
        node_selector                    = var.dashboard_node_selectors
        service_account_name             = kubernetes_service_account.this.metadata[0].name
        termination_grace_period_seconds = 30
        toleration {
          effect = "NoSchedule"
          key    = "node-role.kubernetes.io/master"
        }
        volume {
          name = "kubernetes-dashboard-certs"
          secret {
            secret_name = kubernetes_secret.certs.metadata[0].name
          }
        }
        volume {
          name = "tmp-volume"
          empty_dir {}
        }
      }
    }
  }
}


# -----------------------------------------------------------------------------
# Metrics Scraper
# -----------------------------------------------------------------------------

resource "kubernetes_service" "metrics_scraper" {
  metadata {
    name      = "dashboard-metrics-scraper"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      k8s-app = "dashboard-metrics-scraper"
    }
  }
  spec {
    type = "ClusterIP"
    port {
      port        = 8000
      protocol    = "TCP"
      target_port = 8000
    }
    selector = var.dashboard_node_selectors
  }
}

resource "kubernetes_deployment" "metrics_scraper" {
  metadata {
    name      = "dashboard-metrics-scraper"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      k8s-app = "dashboard-metrics-scraper"
    }
  }
  spec {
    replicas               = 1
    revision_history_limit = 10
    selector {
      match_labels = {
        k8s-app = "dashboard-metrics-scraper"
      }
    }
    template {
      metadata {
        labels = {
          k8s-app = "dashboard-metrics-scraper"
        }
        annotations = {
          "seccomp.security.alpha.kubernetes.io/pod" = "runtime/default"
        }
      }
      spec {
        container {
          name              = "dashboard-metrics-scraper"
          image             = "kubernetesui/metrics-scraper:${var.metrics_scraper_image_tag}"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 8000
            protocol       = "TCP"
          }
          liveness_probe {
            failure_threshold = 3
            http_get {
              path   = "/"
              port   = 8000
              scheme = "HTTP"
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 30
          }
          volume_mount {
            mount_path = "/tmp"
            name       = "tmp-volume"
          }
          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
            run_as_user                = 1001
            run_as_group               = 2001
          }
        }
        service_account_name = kubernetes_service_account.this.metadata[0].name
        node_selector        = var.metrics_scraper_node_selectors
        toleration {
          key    = "node-role.kubernetes.io/master"
          effect = "NoSchedule"
        }
        volume {
          name = "tmp-volume"
          empty_dir {}
        }
      }
    }
  }
}


# -----------------------------------------------------------------------------
# Ingress
# -----------------------------------------------------------------------------

data "aws_acm_certificate" "cert" {
  domain = var.domain
}

resource "kubernetes_ingress" "alb" {
  metadata {
    name      = "alb-ingress"
    namespace = var.nginx_controller_namespace
    annotations = {
      "kubernetes.io/ingress.class"                = "alb"
      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
      "alb.ingress.kubernetes.io/group.name"       = var.domain
      "alb.ingress.kubernetes.io/certificate-arn"  = data.aws_acm_certificate.cert.arn
      "alb.ingress.kubernetes.io/healthcheck-path" = "${var.path}/"
      "alb.ingress.kubernetes.io/listen-ports" = jsonencode([
        { HTTP = 80 },
        { HTTPS = 443 }
      ])
      "alb.ingress.kubernetes.io/actions.ssl-redirect" = jsonencode({
        Type = "redirect",
        RedirectConfig = {
          Protocol   = "HTTPS"
          Port       = "443"
          StatusCode = "HTTP_301"
        }
      })
    }
    labels = {
      app = "dashboard"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = "ssl-redirect"
            service_port = "use-annotation"
          }
        }
        path {
          path = "/*"
          backend {
            service_name = "nginx-ingress-nginx-controller"
            service_port = "http"
          }
        }
      }
    }
  }
}


# -----------------------------------------------------------------------------
# NGINX Ingress
# -----------------------------------------------------------------------------

resource "kubernetes_ingress" "nginx" {
  metadata {
    name      = "dashboard"
    namespace = kubernetes_namespace.this.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/backend-protocol"      = "HTTPS"
      "nginx.ingress.kubernetes.io/rewrite-target"        = "/$2"
      "nginx.ingress.kubernetes.io/configuration-snippet" = "rewrite ^(${var.path})$ $1/ redirect;\n"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          path = "${var.path}(/|$)(.*)"
          backend {
            service_name = kubernetes_service.this.metadata[0].name
            service_port = kubernetes_service.this.spec[0].port[0].port
          }
        }
      }
    }
  }
}
