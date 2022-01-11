<!-- BEGIN_TF_DOCS -->
# Platform Deployment

Deploy platform resources. This includes:
  1. a metrics server;
  2. a cluster autoscaler;
  3. an AWS loadbalancer ingress controller;
  4. an NGINX ingress controller; and
  5. a Kubernetes dashboard.

This module provides public access to resources via an AWS application
loadbalancer. To encrypt traffic an
[AWS ACM certificate](https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html)
must be created prior to running this module. The certificate is identified
by the encoded domain, which is specified by the `domain` input.

Most of the remaining inputs specify application or Helm chart versions and
the node group that should be used for each resource.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster_autoscaler"></a> [cluster\_autoscaler](#module\_cluster\_autoscaler) | ../../modules/cluster_autoscaler | n/a |
| <a name="module_dashboard"></a> [dashboard](#module\_dashboard) | ../../modules/dashboard | n/a |
| <a name="module_eks_admin"></a> [eks\_admin](#module\_eks\_admin) | ../../modules/eks_admin | n/a |
| <a name="module_loadbalancer_controller"></a> [loadbalancer\_controller](#module\_loadbalancer\_controller) | ../../modules/loadbalancer_controller | n/a |
| <a name="module_metrics_server"></a> [metrics\_server](#module\_metrics\_server) | ../../modules/metrics_server | n/a |
| <a name="module_nginx_controller"></a> [nginx\_controller](#module\_nginx\_controller) | ../../modules/nginx_controller | n/a |
| <a name="module_oidc_trust"></a> [oidc\_trust](#module\_oidc\_trust) | ../../modules/oidc_trust | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.core](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_autoscaler_node_selectors"></a> [cluster\_autoscaler\_node\_selectors](#input\_cluster\_autoscaler\_node\_selectors) | cluster autoscaler node selectors | `map(string)` | n/a | yes |
| <a name="input_cluster_autoscaler_version"></a> [cluster\_autoscaler\_version](#input\_cluster\_autoscaler\_version) | cluster autoscaler version | `string` | n/a | yes |
| <a name="input_core_state_bucket"></a> [core\_state\_bucket](#input\_core\_state\_bucket) | S3 bucket for core state | `string` | n/a | yes |
| <a name="input_core_state_key"></a> [core\_state\_key](#input\_core\_state\_key) | S3 key for core state | `string` | n/a | yes |
| <a name="input_core_state_region"></a> [core\_state\_region](#input\_core\_state\_region) | S3 region for core state | `string` | n/a | yes |
| <a name="input_dashboard_metrics_scraper_node_selectors"></a> [dashboard\_metrics\_scraper\_node\_selectors](#input\_dashboard\_metrics\_scraper\_node\_selectors) | Kubernetes dashboard metrics scraper node selectors | `map(string)` | n/a | yes |
| <a name="input_dashboard_metrics_scraper_version"></a> [dashboard\_metrics\_scraper\_version](#input\_dashboard\_metrics\_scraper\_version) | Kubernetes dashboard metrics scraper version | `string` | n/a | yes |
| <a name="input_dashboard_node_selectors"></a> [dashboard\_node\_selectors](#input\_dashboard\_node\_selectors) | Kubernetes dashboard node selectors | `map(string)` | n/a | yes |
| <a name="input_dashboard_version"></a> [dashboard\_version](#input\_dashboard\_version) | Kubernetes dashboard version | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | public loadbalancer domain | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | environment for resource naming and tagging | `string` | n/a | yes |
| <a name="input_loadbalancer_controller_chart_version"></a> [loadbalancer\_controller\_chart\_version](#input\_loadbalancer\_controller\_chart\_version) | LoadBalancer Controller Helm chart version | `string` | n/a | yes |
| <a name="input_loadbalancer_controller_node_selectors"></a> [loadbalancer\_controller\_node\_selectors](#input\_loadbalancer\_controller\_node\_selectors) | LoadBalancer controller node selectors | `map(string)` | n/a | yes |
| <a name="input_metrics_server_node_selectors"></a> [metrics\_server\_node\_selectors](#input\_metrics\_server\_node\_selectors) | metrics server node selectors | `map(string)` | n/a | yes |
| <a name="input_metrics_server_version"></a> [metrics\_server\_version](#input\_metrics\_server\_version) | metrics server version | `string` | n/a | yes |
| <a name="input_nginx_controller_chart_version"></a> [nginx\_controller\_chart\_version](#input\_nginx\_controller\_chart\_version) | NGINX ingress controller Helm chart version | `string` | n/a | yes |
| <a name="input_nginx_controller_node_selectors"></a> [nginx\_controller\_node\_selectors](#input\_nginx\_controller\_node\_selectors) | NGINX ingress controller node selectors | `map(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->