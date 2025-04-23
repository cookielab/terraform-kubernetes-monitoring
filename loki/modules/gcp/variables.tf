variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "storage_location" {
  type        = string
  description = "The location of the storage bucket in GCP"
}

variable "storage_prefix" {
  type        = string
  description = "The prefix for the storage bucket"
  default     = ""
}

variable "rw_bucket_roles" {
  type        = list(string)
  description = "List of roles that need read/write access to the buckets"
  default     = []
}

variable "buckets" {
  type        = list(string)
  description = "List of buckets to create"
  default     = ["chunks"]
}

variable "cloud_provider" {
  type        = string
  description = "The cloud provider to use (gcp, aws)"
  default     = "gcp"
}

variable "namespace" {
  type        = string
  description = "The namespace to deploy the mimir service to"
  default     = "monitoring"
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
