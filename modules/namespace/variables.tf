/*
 * Namespace inputs
 */

variable "name" {
  type        = string
  description = "namespace name"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "enable_fargate" {
  type        = bool
  description = "enable Fargate access for containers in this namespace"
  default     = true
}

variable "fargate_selector_labels" {
  type        = map(string)
  description = "Fargate selector labels"
  default     = {}
}

variable "fargate_subnet_ids" {
  type        = list(string)
  description = "private subnets for Fargate"
}
