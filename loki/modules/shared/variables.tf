variable "project_id" {
  type        = string
  description = "The GCP project ID"
  default     = ""
}

variable "storage_location" {
  type        = string
  description = "The location of the storage bucket (for GCP)"
  default     = "europe-west1"
}

variable "storage_prefix" {
  type        = string
  description = "The prefix for the storage bucket"
  default     = ""
}

variable "namespace" {
  type        = string
  description = "The namespace to deploy the loki service to"
  default     = "monitoring"
}

variable "loki_helm_version" {
  type        = string
  description = "The version of the loki helm chart to use"
  default     = "6.29.0"
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

variable "aws_region" {
  type        = string
  description = "The AWS region"
  default     = "eu-west-1"
}

variable "helm_release_name" {
  type        = string
  description = "The name of the helm release to use"
  default     = "loki"
}

variable "loki" {
  type = object({
    index_prefix = optional(string, "index_")
    index_period = optional(string, "24h")
    serviceAccount = optional(object({
      name        = optional(string, "loki")
      create      = optional(bool, true)
      annotations = optional(map(string), {})
    }), {})
    ruler = optional(object({
      enabled  = optional(bool, false)
      replicas = optional(number, 0)
      resources = optional(object({
        requests = optional(object({
          cpu    = optional(string, "100m")
          memory = optional(string, "100Mi")
        }), {})
        limits = optional(object({
          cpu    = optional(string, "200m")
          memory = optional(string, "200Mi")
        }), {})
      }), {})
    }), {})
    write = optional(object({
      enabled  = optional(bool, true)
      replicas = optional(number, 2)
      resources = optional(object({
        requests = optional(object({
          cpu    = optional(string, "100m")
          memory = optional(string, "512Mi")
        }), {})
        limits = optional(object({
          cpu    = optional(string, "200m")
          memory = optional(string, "512Mi")
        }), {})
      }), {})
    }), {})
    read = optional(object({
      enabled  = optional(bool, true)
      replicas = optional(number, 2)
      resources = optional(object({
        requests = optional(object({
          cpu    = optional(string, "100m")
          memory = optional(string, "100Mi")
        }), {})
        limits = optional(object({
          cpu    = optional(string, "200m")
          memory = optional(string, "200Mi")
        }), {})
      }), {})
    }), {})
    backend = optional(object({
      enabled  = optional(bool, true)
      replicas = optional(number, 1)
      resources = optional(object({
        requests = optional(object({
          cpu    = optional(string, "100m")
          memory = optional(string, "100Mi")
        }), {})
        limits = optional(object({
          cpu    = optional(string, "200m")
          memory = optional(string, "200Mi")
        }), {})
      }), {})
    }), {})
    gateway = optional(object({
      enabled  = optional(bool, true)
      replicas = optional(number, 1)
      resources = optional(object({
        requests = optional(object({
          cpu    = optional(string, "100m")
          memory = optional(string, "100Mi")
        }), {})
        limits = optional(object({
          cpu    = optional(string, "200m")
          memory = optional(string, "200Mi")
        }), {})
      }), {})
    }), {})
    querier = optional(object({
      enabled  = optional(bool, false)
      replicas = optional(number, 0)
      resources = optional(object({
        requests = optional(object({
          cpu    = optional(string, "100m")
          memory = optional(string, "100Mi")
        }), {})
        limits = optional(object({
          cpu    = optional(string, "200m")
          memory = optional(string, "200Mi")
        }), {})
      }), {})
    }), {})
  })
  description = "The Loki configuration"
  default     = {}
}

