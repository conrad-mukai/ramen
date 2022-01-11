/*
 * # Kubeconfig Deployment
 *
 * Generate a kubeconfig file for the EKS cluster created in the core
 * deployment.
 *
 * The only resource this module manages is a local file. Since the file path
 * varies between users, the state will also vary. Because of this we do not
 * configure a Terraform S3 backend and store the state file locally.
 *
 * The inputs for this module should match the backend configuration used for
 * the `core` module.
 */


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

module "kubeconfig" {
  source          = "../../modules/kubeconfig"
  kubeconfig_path = "kubeconfig"
  cluster_name    = data.terraform_remote_state.core.outputs.eks_cluster_name
  cluster_arn     = data.terraform_remote_state.core.outputs.eks_cluster_arn
  endpoint_url    = data.terraform_remote_state.core.outputs.eks_cluster_endpoint
  certificate     = data.terraform_remote_state.core.outputs.eks_cluster_certificate
}
