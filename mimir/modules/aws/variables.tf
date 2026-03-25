variable "namespace" {
  type        = string
  default     = "monitoring"
  description = "The namespace to deploy the mimir service account to"
}

variable "oidc_provider_arn" {
  type        = string
  description = "The OIDC provider ARN"
  default     = ""

  validation {
    condition     = var.use_pod_identity || var.oidc_provider_arn != ""
    error_message = "oidc_provider_arn must be set when use_pod_identity is false."
  }
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

variable "aws_region" {
  type        = string
  description = "The AWS region to use"
  default     = "eu-west-1"
}

variable "use_pod_identity" {
  type        = bool
  description = "Use EKS Pod Identity instead of IRSA for S3 access"
  default     = false
}

variable "cluster_name" {
  type        = string
  description = "The EKS cluster name (required when use_pod_identity is true)"
  default     = ""

  validation {
    condition     = !var.use_pod_identity || var.cluster_name != ""
    error_message = "cluster_name must be set when use_pod_identity is true."
  }
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
        enabled = optional(bool, true)
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
      ingress = optional(object({
        enabled     = optional(bool, false)
        annotations = optional(map(string), {})
        hosts       = optional(list(string), [])
        path        = optional(string, "/")
        pathType    = optional(string, "ImplementationSpecific")
        tls = optional(list(object({
          secretName = optional(string, "mimir-gateway-tls")
          hosts      = optional(list(string), [""])
        })), [])
      }), {})
    }), {})
    runtimeConfig = optional(map(any), {})
  })
  description = "The mimir configuration"
  default     = {}
}
