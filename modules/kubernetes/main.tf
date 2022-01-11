/*
 * # Kubernetes Module
 *
 * This module creates an EKS cluster. This includes:
 *   1. a Kubernetes control plane;
 *   2. worker nodes; and
 *   3. an autoscaler.
 */


# -----------------------------------------------------------------------------
# IAM cluster role.
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "cluster_trust" {
  statement {
    principals {
      identifiers = ["eks.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cluster_role" {
  name               = "${var.env}-eks-cluster"
  assume_role_policy = data.aws_iam_policy_document.cluster_trust.json
}

resource "aws_iam_role_policy_attachment" "cluster_permissions" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}


# -----------------------------------------------------------------------------
# CloudWatch Logs for the EKS control plane logging.
# -----------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "control_plane" {
  name              = "/aws/eks/${var.env}/cluster"
  retention_in_days = var.log_retention
}


# -----------------------------------------------------------------------------
# EKS Cluster. The cluster is configured with public and private access, where
# public access is restricted.
# -----------------------------------------------------------------------------

resource "aws_eks_cluster" "this" {
  name     = var.env
  version  = var.kubernetes_version
  role_arn = aws_iam_role.cluster_role.arn
  vpc_config {
    endpoint_private_access = true
    public_access_cidrs     = var.access_cidrs
    subnet_ids              = var.subnets
  }
  enabled_cluster_log_types = ["api", "audit"]
  depends_on = [
    aws_iam_role_policy_attachment.cluster_permissions,
    aws_cloudwatch_log_group.control_plane
  ]
}


# -----------------------------------------------------------------------------
# OIDC Provider
# -----------------------------------------------------------------------------

data "tls_certificate" "cluster_cert" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "id_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster_cert.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.cluster_cert.url
}

locals {
  oidc_provider = replace(aws_iam_openid_connect_provider.id_provider.url, "https://", "")
}


# -----------------------------------------------------------------------------
# IAM roles for aws-node service account.
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "aws_node_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      values   = ["system:serviceaccount:kube-system:aws-node"]
      variable = "${local.oidc_provider}:sub"
    }
    principals {
      identifiers = [aws_iam_openid_connect_provider.id_provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "aws_node_role" {
  name               = "${var.env}-eks-aws-node"
  assume_role_policy = data.aws_iam_policy_document.aws_node_trust.json
}

resource "aws_iam_role_policy_attachment" "aws_node_permissions" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.aws_node_role.name
}


# -----------------------------------------------------------------------------
# node groups
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "ec2_trust" {
  statement {
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.env}-eks-workers"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}

locals {
  ec2_policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

resource "aws_iam_role_policy_attachment" "ec2_permissions" {
  count      = length(local.ec2_policies)
  policy_arn = local.ec2_policies[count.index]
  role       = aws_iam_role.ec2_role.name
}

resource "aws_eks_node_group" "this" {
  for_each        = var.node_groups
  node_group_name = each.key
  cluster_name    = aws_eks_cluster.this.name
  node_role_arn   = aws_iam_role.ec2_role.arn
  subnet_ids      = var.subnets
  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }
  capacity_type  = each.value.capacity_type
  ami_type       = each.value.ami_type
  instance_types = each.value.instance_types
  tags = {
    Name = "${aws_eks_cluster.this.name}-${each.key}"
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config[0].desired_size]
  }
  depends_on = [aws_iam_role_policy_attachment.ec2_permissions]
}
