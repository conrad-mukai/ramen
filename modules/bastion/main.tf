/*
 * # Bastion Module
 *
 * This module creates bastions that use ec2-instance-connect:
 *
 * https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Connect-using-EC2-Instance-Connect.html
 *
 * This service authenticates users via IAM. Once authenticated a user's public
 * SSH key is copied to the bastion to create a session. The key is removed
 * once a connection is established.
 */


# -----------------------------------------------------------------------------
# EC2 instances
# -----------------------------------------------------------------------------

data "aws_ami" "image" {
  owners      = ["amazon"]
  most_recent = true
  name_regex  = "^amzn2-ami-hvm-2\\.0\\."
}

resource "aws_instance" "this" {
  count                  = var.bastion_count
  ami                    = data.aws_ami.image.id
  instance_type          = var.instance_type
  subnet_id              = element(var.subnets, count.index)
  vpc_security_group_ids = var.security_groups
  tags = {
    Name = format("${var.env}-bastion-%d", count.index + 1)
  }
  lifecycle {
    ignore_changes = [ami]
  }
}
