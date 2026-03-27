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
  default     = ["traces"]
}

variable "cloud_provider" {
  type        = string
  description = "The cloud provider to use (gcp, aws)"
  default     = "gcp"
}

variable "tempo" {
  type = object({
    serviceAccount = optional(object({
      name        = optional(string, "tempo")
      create      = optional(bool, true)
      annotations = optional(map(string), {})
    }), {})
    metricsGenerator = optional(object({
      enabled        = optional(bool, true)
      remoteWriteUrl = optional(string, "")
      processors     = optional(list(string), ["service-graphs", "span-metrics"])
      nodeSelector = optional(map(string), {})
      tolerations = optional(list(object({
        key               = optional(string)
        operator          = optional(string)
        value             = optional(string)
        effect            = optional(string)
        tolerationSeconds = optional(number)
      })), [])
    }), {})
    ingester = optional(object({
      replicas = optional(number, 2)
      zoneAwareReplication = optional(object({
        enabled = optional(bool, false)
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
          cpu    = optional(string, "100m")
          memory = optional(string, "100Mi")
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
          secretName = optional(string, "tempo-gateway-tls")
          hosts      = optional(list(string), [""])
        })), [])
      }), {})
    }), {})
    querier = optional(object({
      enabled      = optional(bool, true)
      nodeSelector = optional(map(string), {})
      tolerations = optional(list(object({
        key               = optional(string)
        operator          = optional(string)
        value             = optional(string)
        effect            = optional(string)
        tolerationSeconds = optional(number)
      })), [])
    }), {})
    traces = optional(object({
      otlp = optional(object({
        http = optional(object({
          enabled = optional(bool, true)
        }), {})
        grpc = optional(object({
          enabled = optional(bool, true)
        }), {})
      }), {})
    }), {})
    test_traces = optional(object({
      enabled                    = optional(bool, false)
      name                       = optional(string, "test-traces")
      telemetrygen_image_version = optional(string, "v0.96.0")
    }), {})
  })
  description = "The tempo configuration"
  default     = {}
}

variable "namespace" {
  type        = string
  description = "The namespace to deploy the tempo service to"
  default     = "monitoring"
}

variable "otel_collector" {
  type = object({
    name      = optional(string, "grafana-alloy-otel-collector")
    namespace = optional(string, "monitoring")
    port      = optional(number, 4317)
  })
  description = "The otel collector configuration"
  default     = {}
}
