/*
 * kubeconfig inputs
 */

variable "kubeconfig_path" {
  type        = string
  description = "local path for kubeconfig"
}

variable "cluster_name" {
  type        = string
  description = "cluster name"
}

variable "endpoint_url" {
  type        = string
  description = "cluster URL"
}

variable "certificate" {
  type        = string
  description = "cluster certificate"
}

variable "cluster_arn" {
  type        = string
  description = "cluster ARN"
}
