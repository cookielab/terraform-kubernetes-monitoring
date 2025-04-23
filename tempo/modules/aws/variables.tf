variable "storage_prefix" {
  type    = string
  default = ""
}

variable "rw_bucket_roles" {
  type        = list(string)
  description = "List of roles that need read/write access to the buckets"
  default     = []
}

variable "oidc_provider_arn" {
  type        = string
  description = "The OIDC provider ARN"
}

variable "cloud_provider" {
  type        = string
  description = "The cloud provider to use (gcp, aws)"
  default     = "aws"
}

variable "buckets" {
  type        = list(string)
  description = "List of buckets to create"
  default     = ["traces"]
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
    }), {})
    ingester = optional(object({
      replicas = optional(number, 2)
      zoneAwareReplication = optional(object({
        enabled = optional(bool, false)
      }), {})
    }), {})
    gateway = optional(object({
      enabled = optional(bool, true)
    }), {})
    querier = optional(object({
      enabled = optional(bool, true)
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
