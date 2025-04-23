locals {
  service_account_name = "loki"
  bucket_prefix        = "loki-"
  loki_config = {
    serviceAccount = {
      name        = var.loki.serviceAccount.name
      create      = var.loki.serviceAccount.create
      annotations = var.loki.serviceAccount.annotations
    }
    loki = {
      schemaConfig = {
        configs = [
          {
            from         = "2025-04-16"
            store        = "tsdb"
            object_store = var.cloud_provider == "gcp" ? "gcs" : var.cloud_provider == "aws" ? "s3" : "filesystem"
            schema       = "v13"
            index = {
              prefix = var.loki.index_prefix
              period = var.loki.index_period
            }
          }
        ]
      }
      storage = {
        bucketNames = {
          chunks = "${var.storage_prefix}${var.storage_bucket_name["${local.bucket_prefix}chunks"]}"
        }
        type = var.cloud_provider == "gcp" ? "gcs" : var.cloud_provider == "aws" ? "s3" : "filesystem"
        s3 = var.cloud_provider == "aws" ? {
          region = var.aws_region
        } : {}
      }

    }
    gateway = {
      enabled   = var.loki.gateway.enabled
      replicas  = var.loki.gateway.replicas
      resources = var.loki.gateway.resources
    }
    write = {
      enabled   = var.loki.write.enabled
      replicas  = var.loki.write.replicas
      resources = var.loki.write.resources
    }
    backend = {
      enabled   = var.loki.backend.enabled
      replicas  = var.loki.backend.replicas
      resources = var.loki.backend.resources
    }
    read = {
      enabled   = var.loki.read.enabled
      replicas  = var.loki.read.replicas
      resources = var.loki.read.resources
    }
    querier = {
      enabled   = var.loki.querier.enabled
      replicas  = var.loki.querier.replicas
      resources = var.loki.querier.resources
    }
    ruler = {
      enabled   = var.loki.ruler.enabled
      replicas  = var.loki.ruler.replicas
      resources = var.loki.ruler.resources
    }
  }
}
