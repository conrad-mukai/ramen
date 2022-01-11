/*
 * cluster autoscaler inputs
 */

variable "env" {
  type        = string
  description = "environment for resource naming and tagging"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "image_tag" {
  type        = string
  description = "cluster autoscaler image tag"
}

variable "oidc_assume_policy" {
  type        = string
  description = "Open ID Connect assume policy"
}

variable "node_selectors" {
  type        = map(string)
  description = "node selectors for deployment"
}
