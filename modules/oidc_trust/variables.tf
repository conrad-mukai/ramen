/*
 * OIDC trust inputs
 */

variable "oidc_provider" {
  type        = string
  description = "Open ID Connect identity provider"
}

variable "oidc_provider_arn" {
  type        = string
  description = "Open ID Connect identity provider ARN"
}
