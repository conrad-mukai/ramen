# Deploy Modules

Each of the sub-directories is a root modules for Terraform deployments. The
following table summarizes what each module deploys.

| Module       | Description                                                                                                   |
|--------------|---------------------------------------------------------------------------------------------------------------|
| `core`       | Creates AWS resources (e.g., VPC, EKS cluster, managed node groups, etc.)                                     |                                                                                         |
| `kubeconfig` | Creates the kubeconfig file for EKS credentials.                                                              |
| `platform`   | Creates Kubernetes resources (e.g., metrics server, cluster autoscaler, dashboard, ingress controllers, etc.) |

The deployments should be executed in the order listed in the table. The
general process for each deployment is:
1. `terraform init` (initialize configuration);
2. `terraform plan` (a dry run); and
3. `terraform apply` (deployment).

## Initialization

Terraform maintains the state of a deployment in a file. The default behavior
is to store the state locally in a file called `terraform.tfstate`. This is
problematic for several reasons. The state file must be maintained to
accurately manage resources. If it is lost then any record of previous work
disappears. Also if multiple engineers are working on the same set of resources
they must share a common state file, which is difficult if the file is stored
locally. In order to alleviate this, the code is configured to store the state
file in S3. This is indicated in the code with the following block:
```terraform
terraform {
  backend "s3" {}
}
```
The `backend` block is intentionally left empty so that the code can be reused
with different backend configurations. All deployments except for `kubeconfig`
contains a file called `tfvars/backend-example-usw2.tfvars` which contains
settings for the S3 state file in `us-west-2`. For example the
`core/tfvars/backend-example-usw2.tfvars` contains:
```terraform
bucket = "EXAMPLE-BUCKET"
key    = "EXAMPLE/core/terraform.tfstate"
region = "us-west-2"
```
To configure the backend make a copy of this file and name the copy by
replacing `example` with the environment and the region code with the intended
target. For example, `backend-sandbox-use1.tfvars`. Replace the settings with
your S3 bucket, key, and region. Store this file in source control so that
other users will use the same state.

Once the backend configuration is saved, you can initialize your Terraform
workspace. If the file was stored in a path called
`tfvars/backend-sandbox-use1.tfvars` then the command to initialize the
workspace is:
```shell
terraform init -backend-config tfvars/backend-sandbox-use1.tfvars
```
If you are reconfiguring a workspace to a different backend then add the
`-reconfigure` flag like so:
```shell
terraform init -backend-config tfvars/backend-prod-use1.tfvars -reconfigure
```

## Dry Run

To run a deployment the inputs must be specified. Like the backend
configuration, the inputs are stored in a `tfvars` file. In each deployment
there is a file called `tfvars/example-usw2.tfvars` which contains an example
deployment in the `us-west-2` region. To specify inputs make a copy of this
file and name the copy by replacing `example` with the environment and the
region with the intended target. For example, `sandbox-use1.tfvars`. Save this
file in source control so other users can use the same inputs. Update the
values in the file, using the documentation in each root module.

Once the inputs are saved, you can execute a dry run. If the file is stored in
a path called `tfvars/sandbox-use1.tfvars` then create a symbolic link called
`terraform.tfvars` in the root directory to the input file and execute a dry
run like so:
```shell
ln -s tfvars/sandbox-use1.tfvars terraform.tfvars
terraform plan
```

## Deployment

Finally, after a successful dry run, the configuration can be deployed. To
deploy simply execute the following:
```shell
terraform apply
```
