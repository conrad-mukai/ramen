<!-- BEGIN_TF_DOCS -->
# Namespace Module

Module to create a Kubernetes namespace and related resources like Fargate
profiles.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.7.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.7.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_fargate_profile.fargate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile) | resource |
| [aws_iam_role.fargate_pod_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.fargate_pod_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [aws_iam_policy_document.trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name | `string` | n/a | yes |
| <a name="input_enable_fargate"></a> [enable\_fargate](#input\_enable\_fargate) | enable Fargate access for containers in this namespace | `bool` | `true` | no |
| <a name="input_fargate_selector_labels"></a> [fargate\_selector\_labels](#input\_fargate\_selector\_labels) | Fargate selector labels | `map(string)` | `{}` | no |
| <a name="input_fargate_subnet_ids"></a> [fargate\_subnet\_ids](#input\_fargate\_subnet\_ids) | private subnets for Fargate | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | namespace name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->