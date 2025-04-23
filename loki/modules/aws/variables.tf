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
  default     = ["chunks"]
}

variable "storage_prefix" {
  type        = string
  description = "The prefix for the storage bucket"
  default     = ""
}

variable "aws_region" {
  type        = string
  description = "The AWS region"
  default     = "eu-west-1"
}

variable "cloud_provider" {
  type        = string
  description = "The cloud provider to use (gcp, aws)"
  default     = "aws"
}

variable "loki" {
  type = object({
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
