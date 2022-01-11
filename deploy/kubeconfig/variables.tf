/*
 * Kubeconfig inputs
 */

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
