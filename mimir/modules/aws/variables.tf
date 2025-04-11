variable "namespace" {
  type        = string
  description = "The namespace to deploy the mimir service account to"
}

variable "oidc_provider_arn" {
  type        = string
  description = "The OIDC provider ARN"
}

variable "buckets" {
  type        = list(string)
  description = "List of buckets to create"
  default     = ["blocks", "alertmanager", "ruler"]
}

variable "storage_prefix" {
  type        = string
  description = "The prefix for the storage bucket"
  default     = ""
}

variable "cloud_provider" {
  type        = string
  description = "The cloud provider to use (gcp, aws)"
  default     = "aws"
}

variable "custom_config" {
  type        = map(any)
  description = "The custom configuration for the mimir service"
  default     = {}
}
