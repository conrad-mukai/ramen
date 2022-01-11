/*
 * # Networking Module
 *
 * This module creates the following:
 *   1. a VPC;
 *   2. public and private subnets;
 *   3. an internet gateway;
 *   4. a NAT gateway;
 *   5. routing tables;
 *   6. security groups for external ssh and http/https access; and
 *   7. security groups for internal and egress traffic.
 */


# -----------------------------------------------------------------------------
# VPC
# -----------------------------------------------------------------------------

resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.env
  }
}


# -----------------------------------------------------------------------------
# Subnets
# Sub-divide the VPC address space into blocks for the public and private
# subnets. The number of availability zones is used to determine CIDR mask
# size for public and private subnets (with private subnets getting a smaller
# mask and subsequent larger address space).
# -----------------------------------------------------------------------------

data "aws_availability_zones" "az_list" {
  state         = "available"
  exclude_names = var.excluded_azs
}

locals {
  private_subnet_new_bits = floor(log(var.az_count, 2)) + 1
  public_subnet_new_bits  = 2 * local.private_subnet_new_bits
  public_subnet_cidrs     = [for i in range(var.az_count) : cidrsubnet(var.cidr, local.public_subnet_new_bits, i)]
  private_subnet_cidrs    = [for i in range(var.az_count) : cidrsubnet(var.cidr, local.private_subnet_new_bits, i + 1)]
}

resource "aws_subnet" "public" {
  count                   = var.az_count
  vpc_id                  = aws_vpc.this.id
  availability_zone       = element(data.aws_availability_zones.az_list.names, count.index)
  cidr_block              = local.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name                               = "${var.env}-public-${element(data.aws_availability_zones.az_list.zone_ids, count.index)}"
    "kubernetes.io/cluster/${var.env}" = "shared"
    "kubernetes.io/role/elb"           = 1
  }
}

resource "aws_subnet" "private" {
  count             = var.az_count
  vpc_id            = aws_vpc.this.id
  availability_zone = element(data.aws_availability_zones.az_list.names, count.index)
  cidr_block        = local.private_subnet_cidrs[count.index]
  tags = {
    Name                               = "${var.env}-private-${element(data.aws_availability_zones.az_list.zone_ids, count.index)}"
    "kubernetes.io/cluster/${var.env}" = "shared"
    "kubernetes.io/role/internal-elb"  = 1
  }
}


# -----------------------------------------------------------------------------
# Gateways
#
# Create an Internet gateway and one or more NAT gateways. Multiple NAT
# gateways can be allocated to reduce intra-region data transfer costs.
# The break-even point for additional NAT gateways is around 1.6 TB/month of
# traffic from private subnets to the Internet.
#
# The elastic IPs for NAT gateways are created but cannot be destroyed through
# Terraform. This is to prevent accidental deletion of the elastic IPs. Since
# the elastic IPs may be shared with external organizations, their loss would
# be extremely detrimental. To delete the elastic IPs remove them from the
# Terraform state. They can then be deleted manually.
# -----------------------------------------------------------------------------

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = var.env
  }
}

resource "aws_eip" "nat_gateways" {
  count = var.nat_gateway_count
  vpc   = true
  depends_on = [
    aws_internet_gateway.this
  ]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = var.env
  }
}

resource "aws_nat_gateway" "this" {
  count         = var.nat_gateway_count
  allocation_id = aws_eip.nat_gateways[count.index].id
  subnet_id     = element(aws_subnet.public[*].id, count.index)
  depends_on = [
    aws_internet_gateway.this
  ]
  tags = {
    Name = "${var.env}-${count.index + 1}"
  }
}


# -----------------------------------------------------------------------------
# Route Tables
# Route tables for the subnets via the gateways are defined here.
# -----------------------------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.env}-public"
  }
}

resource "aws_route" "public-internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = var.nat_gateway_count
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.env}-private-${count.index + 1}"
  }
}

resource "aws_route" "private-nat" {
  count                  = var.nat_gateway_count
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = element(aws_route_table.private[*].id, count.index)
}


# -----------------------------------------------------------------------------
# Security Groups
# Create security groups. One group allows ssh access for external clients.
# Allowed CIDRs are specified with the ssh_access variable. The other groups
# are for internal traffic and egress to the Internet.
# -----------------------------------------------------------------------------

resource "aws_security_group" "ssh" {
  name        = "${var.env}-ssh"
  description = "allow ssh access"
  vpc_id      = aws_vpc.this.id
  ingress {
    cidr_blocks = var.ssh_access
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  tags = {
    Name = "${var.env}-ssh"
  }
}

resource "aws_security_group" "internal" {
  name        = "${var.env}-internal"
  description = "allow internal access"
  vpc_id      = aws_vpc.this.id
  ingress {
    cidr_blocks = [var.cidr]
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }
  tags = {
    Name = "${var.env}-internal"
  }
}

resource "aws_security_group" "egress" {
  name        = "${var.env}-egress"
  description = "allow egress"
  vpc_id      = aws_vpc.this.id
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }
  tags = {
    Name = "${var.env}-egress"
  }
}
