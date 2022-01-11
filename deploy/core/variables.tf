/*
 * core inputs
 */


# General

variable "env" {
  type        = string
  description = "environment name to use in resource naming and tagging"
}


# AWS

variable "region" {
  type        = string
  description = "AWS region"
}


# Network

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "az_count" {
  type        = number
  description = "number of availability zones in VPC"
}

variable "admin_access" {
  type        = list(string)
  description = "list of CIDRs allowed access to bastions and the EKS master"
}


# EKS

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
}
