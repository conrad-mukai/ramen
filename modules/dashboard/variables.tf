/*
 * Kubernetes Dashboard inputs
 */

variable "dashboard_image_tag" {
  type        = string
  description = "kubernetes dashboard image tag"
}

variable "metrics_scraper_image_tag" {
  type        = string
  description = "dashboard metrics scraper image tag"
}

variable "dashboard_node_selectors" {
  type        = map(string)
  description = "node selectors for the dashboard"
}

variable "metrics_scraper_node_selectors" {
  type        = map(string)
  description = "node selectors for the metrics scraper"
}

variable "domain" {
  type        = string
  description = "domain in ACM certificate"
}

variable "path" {
  type        = string
  description = "URL path to dashboard root"
  default     = "/dashboard"
}

variable "nginx_controller_namespace" {
  type        = string
  description = "NGINX ingress controller namespace"
}
