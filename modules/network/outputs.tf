/*
 * network outputs
 */

output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC ID"
}

output "public_subnets" {
  value = [
    for i in range(var.az_count) : {
      id                = aws_subnet.public[i].id
      availability_zone = aws_subnet.public[i].availability_zone
      cidr_block        = aws_subnet.public[i].cidr_block
    }
  ]
  description = "list of public subnet IDs, CIDRs, and availability zones"
}

output "private_subnets" {
  value = [
    for i in range(var.az_count) : {
      id                = aws_subnet.private[i].id
      availability_zone = aws_subnet.private[i].availability_zone
      cidr_block        = aws_subnet.private[i].cidr_block
    }
  ]
  description = "list of private subnet IDs, CIDRs, and availability zones"
}

output "nat_ips" {
  value       = aws_nat_gateway.this.*.public_ip
  description = "list of public IP addresses for NAT gateways"
}

output "ssh_security_group_id" {
  value       = aws_security_group.ssh.id
  description = "security group ID for ssh access"
}

output "internal_security_group_id" {
  value       = aws_security_group.internal.id
  description = "security group ID for internal access"
}

output "egress_security_group_id" {
  value       = aws_security_group.egress.id
  description = "security group ID for egress"
}
