/*
 * # Namespace Module
 *
 * Module to create a Kubernetes namespace and related resources like Fargate
 * profiles.
 */

resource "kubernetes_namespace" "this" {
  metadata {
    name = var.name
  }
}

data "aws_iam_policy_document" "trust" {
  statement {
    principals {
      identifiers = ["eks-fargate-pods.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "fargate_pod_role" {
  assume_role_policy = data.aws_iam_policy_document.trust.json
  name               = "AmazonEKSFargatePodExecutionRole"
}

resource "aws_iam_role_policy_attachment" "fargate_pod_role" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_pod_role.name
}

resource "aws_eks_fargate_profile" "fargate" {
  count                  = var.enable_fargate ? 1 : 0
  cluster_name           = var.cluster_name
  fargate_profile_name   = var.name
  pod_execution_role_arn = aws_iam_role.fargate_pod_role.arn
  subnet_ids             = var.fargate_subnet_ids
  selector {
    namespace = kubernetes_namespace.this.metadata[0].name
    labels    = var.fargate_selector_labels
  }
}
