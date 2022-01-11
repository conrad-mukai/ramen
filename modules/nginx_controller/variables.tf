/*
 * NGINX ingress inputs
 */

variable "chart_version" {
  type        = string
  description = "Helm chart version"
}

variable "node_selectors" {
  type        = map(string)
  description = "node selectors"
}
