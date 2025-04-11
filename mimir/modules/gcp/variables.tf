variable "project_id" {
  type = string
}

variable "storage_location" {
  type = string
}

variable "storage_prefix" {
  type    = string
  default = ""
}

variable "rw_bucket_roles" {
  type        = list(string)
  description = "List of roles that need read/write access to the buckets"
  default     = []
}

variable "buckets" {
  type        = list(string)
  description = "List of buckets to create"
  default     = ["blocks", "alertmanager", "ruler"]
}

variable "cloud_provider" {
  type        = string
  description = "The cloud provider to use (gcp, aws)"
  default     = "gcp"
}

variable "custom_config" {
  type        = map(any)
  description = "The custom configuration for the mimir service"
  default     = {}
}
