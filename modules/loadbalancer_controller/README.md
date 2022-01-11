<!-- BEGIN_TF_DOCS -->
# LoadBalancer Controller Module

This creates a load balancer controller in the EKS cluster. This is
documented here:

https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html#lbc-install-controller

The load balancer controller creates an ALB when an Ingress resource is
created. An NLB is created when a Service of type LoadBalancer is created.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.4.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.4.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.loadbalancer_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.loadbalancer_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.loadbalancer_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_iam_policy_document.loadbalancer_controller_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name | `string` | n/a | yes |
| <a name="input_ecr_region"></a> [ecr\_region](#input\_ecr\_region) | AWS region for ECR | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | environment for resource naming and tagging | `string` | n/a | yes |
| <a name="input_node_selectors"></a> [node\_selectors](#input\_node\_selectors) | node selectors for deployment | `map(string)` | n/a | yes |
| <a name="input_oidc_assume_policy"></a> [oidc\_assume\_policy](#input\_oidc\_assume\_policy) | Open ID Connect assume policy | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->