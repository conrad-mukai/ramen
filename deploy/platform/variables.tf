/*
 * Platform inputs
 */


# general

variable "env" {
  type        = string
  description = "environment for resource naming and tagging"
}

variable "region" {
  type        = string
  description = "AWS region"
}


# core remote state

variable "core_state_bucket" {
  type        = string
  description = "S3 bucket for core state"
}

variable "core_state_key" {
  type        = string
  description = "S3 key for core state"
}

variable "core_state_region" {
  type        = string
  description = "S3 region for core state"
}


# metrics server

variable "metrics_server_version" {
  type        = string
  description = "metrics server version"
}

variable "metrics_server_node_selectors" {
  type        = map(string)
  description = "metrics server node selectors"
}


# cluster autoscaler

variable "cluster_autoscaler_version" {
  type        = string
  description = "cluster autoscaler version"
}

variable "cluster_autoscaler_node_selectors" {
  type        = map(string)
  description = "cluster autoscaler node selectors"
}


# loadbalancer controller

variable "loadbalancer_controller_chart_version" {
  type        = string
  description = "LoadBalancer Controller Helm chart version"
}

variable "loadbalancer_controller_node_selectors" {
  type        = map(string)
  description = "LoadBalancer controller node selectors"
}


# nginx ingress controller

variable "nginx_controller_chart_version" {
  type        = string
  description = "NGINX ingress controller Helm chart version"
}

variable "nginx_controller_node_selectors" {
  type        = map(string)
  description = "NGINX ingress controller node selectors"
}


# ALB

variable "domain" {
  type        = string
  description = "public loadbalancer domain"
}


# kubernetes dashboard

variable "dashboard_version" {
  type        = string
  description = "Kubernetes dashboard version"
}

variable "dashboard_metrics_scraper_version" {
  type        = string
  description = "Kubernetes dashboard metrics scraper version"
}

variable "dashboard_node_selectors" {
  type        = map(string)
  description = "Kubernetes dashboard node selectors"
}

variable "dashboard_metrics_scraper_node_selectors" {
  type        = map(string)
  description = "Kubernetes dashboard metrics scraper node selectors"
}
