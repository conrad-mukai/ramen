/*
 * Kubernetes module inputs
 */


# general

variable "env" {
  type        = string
  description = "environment for resource naming and tagging"
}


# Kubernetes control plan

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version (default is latest)"
  default     = null
}


# Kubernetes workers

variable "node_groups" {
  type = map(object({
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
    capacity_type  = string
    ami_type       = string
    instance_types = list(string)
  }))
  description = "specs for managed node groups"
  validation {
    condition = alltrue([
      for o in values(var.node_groups) :
      o.scaling_config.min_size >= 0
      && o.scaling_config.min_size <= o.scaling_config.desired_size
      && o.scaling_config.desired_size <= o.scaling_config.max_size
      && contains(["ON_DEMAND", "SPOT"], o.capacity_type)
      && contains(["AL2_x86_64", "AL2_x86_64_GPU", "AL2_ARM_64"], o.ami_type)
    ])
    error_message = "Invalid scaling_config, capacity_type, or ami_type in node group specification."
  }
}


# network

variable "subnets" {
  type        = list(string)
  description = "subnets for worker nodes"
}

variable "access_cidrs" {
  type        = list(string)
  description = "list of CIDRs with access to the public API"
  default     = ["0.0.0.0/0"]
}


# logging

variable "log_retention" {
  type        = number
  description = "EKS control plane log retention in days"
  default     = 7
}
