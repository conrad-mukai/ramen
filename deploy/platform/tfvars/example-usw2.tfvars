# general
env = "EXAMPLE"

# AWS
region = "us-west-2"

# public domain
domain = "aws.example.com"

# core state
core_state_bucket = "EXAMPLE-BUCKET"
core_state_key    = "EXAMPLE/core/terraform.tfstate"
core_state_region = "us-west-2"

# metrics server
metrics_server_version = "v0.5.2"
metrics_server_node_selectors = {
  "eks.amazonaws.com/nodegroup" = "on_demand"
}

# cluster autoscaler
cluster_autoscaler_version = "v1.21.0"
cluster_autoscaler_node_selectors = {
  "eks.amazonaws.com/nodegroup" = "on_demand"
}

# loadbalancer controller
loadbalancer_controller_chart_version = "1.3.3" # appVersion: v2.3.1
loadbalancer_controller_node_selectors = {
  "eks.amazonaws.com/nodegroup" = "on_demand"
}

# nginx ingress controller
nginx_controller_chart_version = "4.0.13" # appVersion: v1.1.0
nginx_controller_node_selectors = {
  "eks.amazonaws.com/nodegroup" = "spot"
}

# kubernetes dashboard
dashboard_version                 = "v2.0.5"
dashboard_metrics_scraper_version = "v1.0.6"
dashboard_node_selectors = {
  "eks.amazonaws.com/nodegroup" = "spot"
}
dashboard_metrics_scraper_node_selectors = {
  "eks.amazonaws.com/nodegroup" = "spot"
}
