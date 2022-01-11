/*
 * Kubernetes module outputs
 */


# EKS

output "cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "EKS cluster name"
}

output "cluster_arn" {
  value       = aws_eks_cluster.this.arn
  description = "EKS cluster ARN"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "EKS cluster URL"
}

output "cluster_certificate" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  description = "EKS cluster certificate"
}

output "oidc_provider" {
  value       = local.oidc_provider
  description = "Open ID Connect identy provider"
}

output "oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.id_provider.arn
  description = "Open ID Connect identity provider ARN"
}
