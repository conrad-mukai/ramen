/*
 * core outputs
 */


# Bastion

output "bastion_instance_ids" {
  value       = module.bastion.instance_ids
  description = "bastion instance IDs"
}


# EKS

output "eks_cluster_name" {
  value       = module.kubernetes.cluster_name
  description = "EKS cluster name"
}

output "eks_cluster_arn" {
  value       = module.kubernetes.cluster_arn
  description = "EKS cluster ARN"
}

output "eks_cluster_endpoint" {
  value       = module.kubernetes.cluster_endpoint
  description = "EKS cluster URL"
}

output "eks_cluster_certificate" {
  value       = module.kubernetes.cluster_certificate
  description = "EKS cluster certificate"
}

output "oidc_provider" {
  value       = module.kubernetes.oidc_provider
  description = "EKS Open ID Connect provider"
}

output "oidc_provider_arn" {
  value       = module.kubernetes.oidc_provider_arn
  description = "EKS Open ID Connect provider ARN"
}
