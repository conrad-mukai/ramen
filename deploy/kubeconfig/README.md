<!-- BEGIN_TF_DOCS -->
# Kubeconfig Deployment

Generate a kubeconfig file for the EKS cluster created in the core
deployment.

The only resource this module manages is a local file. Since the file path
varies between users, the state will also vary. Because of this we do not
configure a Terraform S3 backend and store the state file locally.

The inputs for this module should match the backend configuration used for
the `core` module.

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
| <a name="module_kubeconfig"></a> [kubeconfig](#module\_kubeconfig) | ../../modules/kubeconfig | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.core](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_core_state_bucket"></a> [core\_state\_bucket](#input\_core\_state\_bucket) | S3 bucket for core state | `string` | n/a | yes |
| <a name="input_core_state_key"></a> [core\_state\_key](#input\_core\_state\_key) | S3 key for core state | `string` | n/a | yes |
| <a name="input_core_state_region"></a> [core\_state\_region](#input\_core\_state\_region) | S3 region for core state | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->