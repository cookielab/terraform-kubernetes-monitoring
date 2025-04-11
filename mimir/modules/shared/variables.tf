variable "project_id" {
  type        = string
  description = "The GCP project ID"
  default     = ""
}

variable "storage_location" {
  type        = string
  description = "The location of the storage bucket"
  default     = "europe-west1"
}

variable "storage_prefix" {
  type    = string
  default = ""
}

variable "namespace" {
  type    = string
  default = "monitoring"
}

variable "mimir_helm_version" {
  type    = string
  default = "5.8.0-weekly.335"
}

variable "rw_bucket_roles" {
  type        = list(string)
  description = "List of roles that need read/write access to the buckets"
  default     = []
}

variable "oidc_provider_arn" {
  type        = string
  description = "The OIDC provider ARN"
  default     = ""
}

variable "storage_bucket_name" {
  type        = map(string)
  description = "The name of the storage bucket"
  default     = {}
}

variable "cloud_provider" {
  type        = string
  description = "The cloud provider to use (gcp, aws)"
}

variable "custom_config" {
  type        = map(any)
  description = "The custom configuration for the mimir service"
  default     = {}
}
