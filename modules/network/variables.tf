/*
 * networking inputs
 */

variable "env" {
  type        = string
  description = "environment to use in resource names and tags"
}

variable "cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "az_count" {
  type        = number
  description = "number of availability zones to use"
}

variable "excluded_azs" {
  type        = list(string)
  description = "names of availability zones to avoid"
  default     = []
}

variable "nat_gateway_count" {
  type        = number
  description = "number of NAT gateways"
  default     = 1
}

variable "ssh_access" {
  type        = list(string)
  description = "CIDR blocks with ssh access"
  default     = ["0.0.0.0/0"]
}
