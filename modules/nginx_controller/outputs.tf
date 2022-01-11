/*
 * NGINX ingress controller outputs
 */

output "namespace" {
  value       = kubernetes_namespace.this.metadata[0].name
  description = "NGINX ingress controller namespace"
}
