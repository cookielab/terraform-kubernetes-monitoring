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
  description = "The namespace to deploy the tempo service to"
  default     = "monitoring"
}

variable "tempo_helm_version" {
  type        = string
  description = "The version of the tempo helm chart to use"
  default     = "1.34.0"
}

variable "helm_release_name" {
  type        = string
  description = "The name of the helm release to use"
  default     = "tempo"
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
    }), {})
    ingester = optional(object({
      replicas = optional(number, 2)
      zoneAwareReplication = optional(object({
        enabled = optional(bool, false)
      }), {})
      resources = optional(object({
        requests = optional(object({
          cpu    = optional(string, "100m")
          memory = optional(string, "256Mi")
        }), {})
        limits = optional(object({
          cpu    = optional(string, "100m")
          memory = optional(string, "256Mi")
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
          cpu    = optional(string, "100m")
          memory = optional(string, "100Mi")
        }), {})
      }), {})
    }), {})
    querier = optional(object({
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

variable "otel_collector" {
  type = object({
    name      = optional(string, "grafana-alloy-otel-collector")
    namespace = optional(string, "monitoring")
    port      = optional(number, 4317)
  })
  description = "The otel collector configuration"
}

