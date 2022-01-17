<!-- BEGIN_TF_DOCS -->
# Core Deployment

This module defines AWS resources used by other deployments. This includes:
  1. a network;
  2. bastion servers; and
  3. an EKS Kubernetes cluster.

A key input for this module is the `node_groups` map. The map defines the
[AWS managed node groups](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html).
The map key is the node group name and the value the node group
configuration. The `capacity_type` field in the configuration object
must be set to either `SPOT` or `ON_DEMAND`, indicating the pricing type. If
`capacity_type` is `SPOT` then multiple values should be specified for
`instance_types`.

The `ami_type` field indicates the type of OS. Valid values for it are
`AL2_x86_64`, `AL2_x86_64_GPU`, or `AL2_ARM_64` where each corresponds to a
version of Amazon Linux 2. The `ami_type` field indicates choices that can
be provided in the `instance_types` list. For example, the following table
indicates some of the instance type families that correspond to an
`ami_type`:

| `ami_type` | instance type families |
|----------|----------------|
| `AL2_x86_64` | `m5`<br/>`m5d`<br/>`m5a`<br/>`m5ad`<br/>`m5n`<br/>`m5dn`<br/>`m5zn`<br/>`m4` |
| `AL2_x86_64_GPU` | `g5`<br/>`g5g`<br/>`g4dn`<br/>`g4ad`<br/>`g3` |
| `AL2_ARM_64` | `m6g`<br/>`m6gd`<br/>`m6i`<br/>`m6a` |

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ../../modules/bastion | n/a |
| <a name="module_kubernetes"></a> [kubernetes](#module\_kubernetes) | ../../modules/kubernetes | n/a |
| <a name="module_network"></a> [network](#module\_network) | ../../modules/network | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_access"></a> [admin\_access](#input\_admin\_access) | list of CIDRs allowed access to bastions and the EKS master | `list(string)` | n/a | yes |
| <a name="input_az_count"></a> [az\_count](#input\_az\_count) | number of availability zones in VPC | `number` | n/a | yes |
| <a name="input_bastion_count"></a> [bastion\_count](#input\_bastion\_count) | number of bastions to create | `number` | `1` | no |
| <a name="input_env"></a> [env](#input\_env) | environment name to use in resource naming and tagging | `string` | n/a | yes |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | specs for managed node groups | <pre>map(object({<br>    scaling_config = object({<br>      desired_size = number<br>      max_size     = number<br>      min_size     = number<br>    })<br>    capacity_type  = string<br>    ami_type       = string<br>    instance_types = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_instance_ids"></a> [bastion\_instance\_ids](#output\_bastion\_instance\_ids) | bastion instance IDs |
| <a name="output_eks_cluster_arn"></a> [eks\_cluster\_arn](#output\_eks\_cluster\_arn) | EKS cluster ARN |
| <a name="output_eks_cluster_certificate"></a> [eks\_cluster\_certificate](#output\_eks\_cluster\_certificate) | EKS cluster certificate |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | EKS cluster URL |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | EKS cluster name |
| <a name="output_oidc_provider"></a> [oidc\_provider](#output\_oidc\_provider) | EKS Open ID Connect provider |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | EKS Open ID Connect provider ARN |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | private subnet IDs |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | public subnet IDs |
<!-- END_TF_DOCS -->