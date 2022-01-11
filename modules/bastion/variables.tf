/*
 * bastion inputs
 */

variable "env" {
  type        = string
  description = "environment to use in tagging"
}

variable "bastion_count" {
  type        = number
  description = "number of bastions to create"
  default     = 1
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.nano"
}

variable "subnets" {
  type        = list(string)
  description = "list of subnet IDs"
}

variable "security_groups" {
  type        = list(string)
  description = "list of security group IDs"
}
