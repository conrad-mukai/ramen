/*
 * OIDC trust outputs
 */

output "assume_policy" {
  value       = data.aws_iam_policy_document.trust.json
  description = "JSON assume policy"
}
