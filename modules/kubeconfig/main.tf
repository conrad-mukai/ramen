/*
 * # Kubeconfig
 *
 * Generate a local kubeconfig file.
 */


# -----------------------------------------------------------------------------
# kubeconfig
# -----------------------------------------------------------------------------

resource "local_file" "this" {
  filename        = var.kubeconfig_path
  file_permission = "0700"
  content = templatefile("${path.module}/templates/kubeconfig.tftpl", {
    endpoint_url = var.endpoint_url
    certificate  = var.certificate
    cluster_name = var.cluster_name
    cluster_arn  = var.cluster_arn
  })
}
