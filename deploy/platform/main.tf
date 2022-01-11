/*
 * # Platform Deployment
 *
 * Deploy platform resources. This includes:
 *   1. a metrics server;
 *   2. a cluster autoscaler;
 *   3. an AWS loadbalancer ingress controller;
 *   4. an NGINX ingress controller; and
 *   5. a Kubernetes dashboard.
 *
 * This module provides public access to resources via an AWS application
 * loadbalancer. To encrypt traffic an
 * [AWS ACM certificate](https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html)
 * must be created prior to running this module. The certificate is identified
 * by the encoded domain, which is specified by the `domain` input.
 *
 * Most of the remaining inputs specify application or Helm chart versions and
 * the node group that should be used for each resource.
 */


# -----------------------------------------------------------------------------
# Provider Configuration
# -----------------------------------------------------------------------------

terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  config_path = "../kubeconfig/kubeconfig"
}

provider "helm" {
  kubernetes {
    config_path = "../kubeconfig/kubeconfig"
  }
}


# -----------------------------------------------------------------------------
# Core State
# -----------------------------------------------------------------------------

data "terraform_remote_state" "core" {
  backend = "s3"
  config = {
    bucket = var.core_state_bucket
    key    = var.core_state_key
    region = var.core_state_region
  }
}


# -----------------------------------------------------------------------------
# EKS Admin
# -----------------------------------------------------------------------------

module "eks_admin" {
  source = "../../modules/eks_admin"
}


# -----------------------------------------------------------------------------
# Metrics Server
# -----------------------------------------------------------------------------

module "metrics_server" {
  source         = "../../modules/metrics_server"
  image_tag      = var.metrics_server_version
  node_selectors = var.metrics_server_node_selectors
}


# -----------------------------------------------------------------------------
# OIDC Trust Policy
# -----------------------------------------------------------------------------

module "oidc_trust" {
  source            = "../../modules/oidc_trust"
  oidc_provider     = data.terraform_remote_state.core.outputs.oidc_provider
  oidc_provider_arn = data.terraform_remote_state.core.outputs.oidc_provider_arn
}


# -----------------------------------------------------------------------------
# Cluster Autoscaler
# -----------------------------------------------------------------------------

module "cluster_autoscaler" {
  source             = "../../modules/cluster_autoscaler"
  env                = var.env
  image_tag          = var.cluster_autoscaler_version
  cluster_name       = data.terraform_remote_state.core.outputs.eks_cluster_name
  oidc_assume_policy = module.oidc_trust.assume_policy
  node_selectors     = var.cluster_autoscaler_node_selectors
}



# -----------------------------------------------------------------------------
# LoadBalancer Controller
# -----------------------------------------------------------------------------

module "loadbalancer_controller" {
  source             = "../../modules/loadbalancer_controller"
  env                = var.env
  chart_version      = var.loadbalancer_controller_chart_version
  cluster_name       = data.terraform_remote_state.core.outputs.eks_cluster_name
  ecr_region         = var.region
  oidc_assume_policy = module.oidc_trust.assume_policy
  node_selectors     = var.loadbalancer_controller_node_selectors
}


# -----------------------------------------------------------------------------
# NGINX Ingress Controller
# -----------------------------------------------------------------------------

module "nginx_controller" {
  source         = "../../modules/nginx_controller"
  chart_version  = var.nginx_controller_chart_version
  node_selectors = var.nginx_controller_node_selectors
}


# -----------------------------------------------------------------------------
# Kubernetes Dashboard
# -----------------------------------------------------------------------------

module "dashboard" {
  source                         = "../../modules/dashboard"
  dashboard_image_tag            = var.dashboard_version
  metrics_scraper_image_tag      = var.dashboard_metrics_scraper_version
  dashboard_node_selectors       = var.dashboard_node_selectors
  metrics_scraper_node_selectors = var.dashboard_metrics_scraper_node_selectors
  domain                         = var.domain
  nginx_controller_namespace     = module.nginx_controller.namespace
  depends_on = [
    module.nginx_controller,
    module.loadbalancer_controller
  ]
}
