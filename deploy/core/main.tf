/*
 * # Core Deployment
 *
 * This module defines AWS resources used by other deployments. This includes:
 *   1. a network;
 *   2. bastion servers; and
 *   3. an EKS Kubernetes cluster.
 *
 * A key input for this module is the `node_groups` map. The map defines the
 * [AWS managed node groups](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html).
 * The map key is the node group name and the value the node group
 * configuration. The `capacity_type` field in the configuration object
 * must be set to either `SPOT` or `ON_DEMAND`, indicating the pricing type. If
 * `capacity_type` is `SPOT` then multiple values should be specified for
 * `instance_types`.
 *
 * The `ami_type` field indicates the type of OS. Valid values for it are
 * `AL2_x86_64`, `AL2_x86_64_GPU`, or `AL2_ARM_64` where each corresponds to a
 * version of Amazon Linux 2. The `ami_type` field indicates choices that can
 * be provided in the `instance_types` list. For example, the following table
 * indicates some of the instance type families that correspond to an
 * `ami_type`:
 *
 * | `ami_type` | instance type families |
 * |----------|----------------|
 * | `AL2_x86_64` | `m5`<br/>`m5d`<br/>`m5a`<br/>`m5ad`<br/>`m5n`<br/>`m5dn`<br/>`m5zn`<br/>`m4` |
 * | `AL2_x86_64_GPU` | `g5`<br/>`g5g`<br/>`g4dn`<br/>`g4ad`<br/>`g3` |
 * | `AL2_ARM_64` | `m6g`<br/>`m6gd`<br/>`m6i`<br/>`m6a` |
 */


# -----------------------------------------------------------------------------
# Provider Configuration
# -----------------------------------------------------------------------------

terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region
}


# -----------------------------------------------------------------------------
# Network
# -----------------------------------------------------------------------------

module "network" {
  source     = "../../modules/network"
  env        = var.env
  cidr       = var.vpc_cidr
  az_count   = var.az_count
  ssh_access = var.admin_access
}


# -----------------------------------------------------------------------------
# Bastions
# -----------------------------------------------------------------------------

module "bastion" {
  source  = "../../modules/bastion"
  env     = var.env
  subnets = module.network.public_subnets[*].id
  security_groups = [
    module.network.ssh_security_group_id,
    module.network.egress_security_group_id
  ]
}


# -----------------------------------------------------------------------------
# EKS
# -----------------------------------------------------------------------------

module "kubernetes" {
  source       = "../../modules/kubernetes"
  env          = var.env
  subnets      = module.network.private_subnets[*].id
  access_cidrs = var.admin_access
  node_groups  = var.node_groups
}
