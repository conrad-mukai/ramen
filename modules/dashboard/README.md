<!-- BEGIN_TF_DOCS -->
# Kubernetes Dashboard

This module deploys a Kubernetes dashboard. The deployment is based upon:

https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html
https://aws.amazon.com/premiumsupport/knowledge-center/eks-kubernetes-dashboard-custom-path/

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.7.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.7.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_cluster_role.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_config_map.settings](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_deployment.metrics_scraper](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_ingress.alb](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress) | resource |
| [kubernetes_ingress.nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_role.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) | resource |
| [kubernetes_role_binding.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_secret.certs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.csrf](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.key_holder](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.metrics_scraper](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service_account.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dashboard_image_tag"></a> [dashboard\_image\_tag](#input\_dashboard\_image\_tag) | kubernetes dashboard image tag | `string` | n/a | yes |
| <a name="input_dashboard_node_selectors"></a> [dashboard\_node\_selectors](#input\_dashboard\_node\_selectors) | node selectors for the dashboard | `map(string)` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | domain in ACM certificate | `string` | n/a | yes |
| <a name="input_metrics_scraper_image_tag"></a> [metrics\_scraper\_image\_tag](#input\_metrics\_scraper\_image\_tag) | dashboard metrics scraper image tag | `string` | n/a | yes |
| <a name="input_metrics_scraper_node_selectors"></a> [metrics\_scraper\_node\_selectors](#input\_metrics\_scraper\_node\_selectors) | node selectors for the metrics scraper | `map(string)` | n/a | yes |
| <a name="input_nginx_controller_namespace"></a> [nginx\_controller\_namespace](#input\_nginx\_controller\_namespace) | NGINX ingress controller namespace | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | URL path to dashboard root | `string` | `"/dashboard"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->