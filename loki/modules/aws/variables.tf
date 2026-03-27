variable "namespace" {
  type        = string
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
      nodeSelector = optional(map(string), {})
      tolerations = optional(list(object({
        key               = optional(string)
        operator          = optional(string)
        value             = optional(string)
        effect            = optional(string)
        tolerationSeconds = optional(number)
      })), [])
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
      nodeSelector = optional(map(string), {})
      tolerations = optional(list(object({
        key               = optional(string)
        operator          = optional(string)
        value             = optional(string)
        effect            = optional(string)
        tolerationSeconds = optional(number)
      })), [])
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
      nodeSelector = optional(map(string), {})
      tolerations = optional(list(object({
        key               = optional(string)
        operator          = optional(string)
        value             = optional(string)
        effect            = optional(string)
        tolerationSeconds = optional(number)
      })), [])
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
      nodeSelector = optional(map(string), {})
      tolerations = optional(list(object({
        key               = optional(string)
        operator          = optional(string)
        value             = optional(string)
        effect            = optional(string)
        tolerationSeconds = optional(number)
      })), [])
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
      nodeSelector = optional(map(string), {})
      tolerations = optional(list(object({
        key               = optional(string)
        operator          = optional(string)
        value             = optional(string)
        effect            = optional(string)
        tolerationSeconds = optional(number)
      })), [])
      ingress = optional(object({
        enabled     = optional(bool, false)
        annotations = optional(map(string), {})
        hosts       = optional(list(string), [])
        path        = optional(string, "/")
        pathType    = optional(string, "ImplementationSpecific")
        tls = optional(list(object({
          secretName = optional(string, "loki-gateway-tls")
          hosts      = optional(list(string), [""])
        })), [])
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
      nodeSelector = optional(map(string), {})
      tolerations = optional(list(object({
        key               = optional(string)
        operator          = optional(string)
        value             = optional(string)
        effect            = optional(string)
        tolerationSeconds = optional(number)
      })), [])
    }), {})
  })
  description = "The Loki configuration"
  default     = {}
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
