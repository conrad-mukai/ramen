/*
 * loadbalancer controller inputs
 */

variable "env" {
  type        = string
  description = "environment for resource naming and tagging"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "chart_version" {
  type        = string
  description = "Helm chart version"
}

variable "ecr_region" {
  type        = string
  description = "AWS region for ECR"
}

variable "oidc_assume_policy" {
  type        = string
  description = "Open ID Connect assume policy"
}

variable "node_selectors" {
  type        = map(string)
  description = "node selectors for deployment"
}
