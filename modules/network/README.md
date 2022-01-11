<!-- BEGIN_TF_DOCS -->
# Networking Module

This module creates the following:
  1. a VPC;
  2. public and private subnets;
  3. an internet gateway;
  4. a NAT gateway;
  5. routing tables;
  6. security groups for external ssh and http/https access; and
  7. security groups for internal and egress traffic.

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
| [aws_eip.nat_gateways](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private-nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public-internet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.az_list](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_count"></a> [az\_count](#input\_az\_count) | number of availability zones to use | `number` | n/a | yes |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | VPC CIDR | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | environment to use in resource names and tags | `string` | n/a | yes |
| <a name="input_excluded_azs"></a> [excluded\_azs](#input\_excluded\_azs) | names of availability zones to avoid | `list(string)` | `[]` | no |
| <a name="input_nat_gateway_count"></a> [nat\_gateway\_count](#input\_nat\_gateway\_count) | number of NAT gateways | `number` | `1` | no |
| <a name="input_ssh_access"></a> [ssh\_access](#input\_ssh\_access) | CIDR blocks with ssh access | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_egress_security_group_id"></a> [egress\_security\_group\_id](#output\_egress\_security\_group\_id) | security group ID for egress |
| <a name="output_internal_security_group_id"></a> [internal\_security\_group\_id](#output\_internal\_security\_group\_id) | security group ID for internal access |
| <a name="output_nat_ips"></a> [nat\_ips](#output\_nat\_ips) | list of public IP addresses for NAT gateways |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | list of private subnet IDs, CIDRs, and availability zones |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | list of public subnet IDs, CIDRs, and availability zones |
| <a name="output_ssh_security_group_id"></a> [ssh\_security\_group\_id](#output\_ssh\_security\_group\_id) | security group ID for ssh access |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
<!-- END_TF_DOCS -->