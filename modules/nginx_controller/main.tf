/*
 * # NGINX Ingress Controller Module
 *
 * Create an NGINX ingress controller.
 */


# -----------------------------------------------------------------------------
# NGINX Ingress Controller
# -----------------------------------------------------------------------------

resource "kubernetes_namespace" "this" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "this" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.chart_version
  name       = "nginx"
  namespace  = kubernetes_namespace.this.metadata[0].name
  set {
    name  = "controller.service.type"
    value = "NodePort"
  }
  dynamic "set" {
    for_each = var.node_selectors
    content {
      name  = "controller.nodeSelector.${replace(set.key, ".", "\\.")}"
      value = set.value
    }
  }
}
