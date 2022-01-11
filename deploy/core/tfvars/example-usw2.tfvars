# Core Settings

# General
env = "EXAMPLE"

# AWS
region = "us-west-2"

# Network
vpc_cidr     = "10.0.0.0/16"
az_count     = 3
admin_access = ["1.1.1.1/32"]

# EKS
node_groups = {
  spot = {
    scaling_config = {
      desired_size = 1
      max_size     = 10
      min_size     = 0
    }
    capacity_type = "SPOT"
    ami_type      = "AL2_x86_64"
    instance_types = [
      "m5.large", "m5d.large", "m5a.large", "m5ad.large", "m5n.large",
      "m5dn.large"
    ]
  }
  on_demand = {
    scaling_config = {
      desired_size = 1
      max_size     = 10
      min_size     = 0
    }
    capacity_type  = "ON_DEMAND"
    ami_type       = "AL2_x86_64"
    instance_types = ["m5.large"]
  }
}
