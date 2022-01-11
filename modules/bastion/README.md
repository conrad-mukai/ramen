<!-- BEGIN_TF_DOCS -->
# Bastion Module

This module creates bastions that use ec2-instance-connect:

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Connect-using-EC2-Instance-Connect.html

This service authenticates users via IAM. Once authenticated a user's public
SSH key is copied to the bastion to create a session. The key is removed
once a connection is established.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_ami.image](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_count"></a> [bastion\_count](#input\_bastion\_count) | number of bastions to create | `number` | `1` | no |
| <a name="input_env"></a> [env](#input\_env) | environment to use in tagging | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type | `string` | `"t3.nano"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | list of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | list of subnet IDs | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | instance IDs |
<!-- END_TF_DOCS -->