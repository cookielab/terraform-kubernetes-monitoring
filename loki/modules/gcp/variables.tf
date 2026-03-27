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
