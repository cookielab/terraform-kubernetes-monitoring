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
  description = "The namespace to deploy the mimir service to"
  default     = "monitoring"
}

variable "mimir_helm_version" {
  type        = string
  description = "The version of the mimir helm chart to use"
  default     = "5.8.0-weekly.335"
}

variable "helm_release_name" {
  type        = string
  description = "The name of the helm release to use"
  default     = "mimir"
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
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

variable "mimir" {
  type = object({
    serviceAccount = optional(object({
      name        = optional(string, "mimir")
      create      = optional(bool, true)
      annotations = optional(map(string), {})
    }), {})
    ingester = optional(object({
      replicas = optional(number, 2)
      zoneAwareReplication = optional(object({
        enabled = optional(bool, false)
      }), {})
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
    store_gateway = optional(object({
      replicas = optional(number, 1)
      zoneAwareReplication = optional(object({
        enabled = optional(bool, false)
      }), {})
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
    ruler = optional(object({
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
    compactor = optional(object({
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
    alertmanager = optional(object({
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
    distributor = optional(object({
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
    runtimeConfig = optional(map(any), {})
  })
  description = "The mimir configuration"
  default     = {}
}

