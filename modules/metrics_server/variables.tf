/*
 * Metrics Server Inputs
 */

variable "image_tag" {
  type        = string
  description = "metrics server image tag"
}

variable "node_selectors" {
  type        = map(string)
  description = "node selectors for the metrics server"
}
