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
      enabled      = var.loki.gateway.enabled
      replicas     = var.loki.gateway.replicas
      resources    = var.loki.gateway.resources
      nodeSelector = var.loki.gateway.nodeSelector
      tolerations  = var.loki.gateway.tolerations
      ingress = {
        enabled     = var.loki.gateway.ingress.enabled
        annotations = var.loki.gateway.ingress.annotations
        hosts = [for host in var.loki.gateway.ingress.hosts : {
          host = host
          paths = [{
            path     = var.loki.gateway.ingress.path
            pathType = var.loki.gateway.ingress.pathType
          }]
        }]
        tls = var.loki.gateway.ingress.tls
      }
    }
    write = {
      enabled      = var.loki.write.enabled
      replicas     = var.loki.write.replicas
      resources    = var.loki.write.resources
      nodeSelector = var.loki.write.nodeSelector
      tolerations  = var.loki.write.tolerations
    }
    backend = {
      enabled      = var.loki.backend.enabled
      replicas     = var.loki.backend.replicas
      resources    = var.loki.backend.resources
      nodeSelector = var.loki.backend.nodeSelector
      tolerations  = var.loki.backend.tolerations
    }
    read = {
      enabled      = var.loki.read.enabled
      replicas     = var.loki.read.replicas
      resources    = var.loki.read.resources
      nodeSelector = var.loki.read.nodeSelector
      tolerations  = var.loki.read.tolerations
    }
    querier = {
      enabled      = var.loki.querier.enabled
      replicas     = var.loki.querier.replicas
      resources    = var.loki.querier.resources
      nodeSelector = var.loki.querier.nodeSelector
      tolerations  = var.loki.querier.tolerations
    }
    ruler = {
      enabled      = var.loki.ruler.enabled
      replicas     = var.loki.ruler.replicas
      resources    = var.loki.ruler.resources
      nodeSelector = var.loki.ruler.nodeSelector
      tolerations  = var.loki.ruler.tolerations
    }
  }
}
