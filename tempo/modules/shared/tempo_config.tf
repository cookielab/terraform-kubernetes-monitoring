locals {
  tempo_service_account_name = "tempo"
  bucket_prefix              = "tempo-"

  storage_configs = {
    trace = {
      gcp = {
        backend = "gcs"
        gcs = {
          bucket_name = "${var.storage_prefix}${var.storage_bucket_name["${local.bucket_prefix}traces"]}"
        }
      }
      aws = {
        backend = "s3"
        s3 = {
          bucket   = "${var.storage_prefix}${var.storage_bucket_name["${local.bucket_prefix}traces"]}"
          endpoint = "s3.amazonaws.com"
          region   = var.aws_region
        }
      }
    }
  }
  tempo_config = {
    serviceAccount = {
      name        = var.tempo.serviceAccount.name
      create      = var.tempo.serviceAccount.create
      annotations = var.tempo.serviceAccount.annotations
    }
    storage = {
      for key, value in local.storage_configs :
      key => {
        backend = var.cloud_provider == "gcp" ? value.gcp.backend : var.cloud_provider == "aws" ? value.aws.backend : ""
        gcs     = var.cloud_provider == "gcp" ? value.gcp.gcs : {}
        s3      = var.cloud_provider == "aws" ? value.aws.s3 : {}
      }
    }
    ingester = {
      replicas             = var.tempo.ingester.replicas
      zoneAwareReplication = var.tempo.ingester.zoneAwareReplication
      resources            = var.tempo.ingester.resources
      nodeSelector         = var.tempo.ingester.nodeSelector
      tolerations          = var.tempo.ingester.tolerations
    }
    gateway = {
      enabled      = var.tempo.gateway.enabled
      replicas     = var.tempo.gateway.replicas
      resources    = var.tempo.gateway.resources
      nodeSelector = var.tempo.gateway.nodeSelector
      tolerations  = var.tempo.gateway.tolerations
      ingress = {
        enabled     = var.tempo.gateway.ingress.enabled
        annotations = var.tempo.gateway.ingress.annotations
        hosts = [for host in var.tempo.gateway.ingress.hosts : {
          host = host
          paths = [{
            path     = var.tempo.gateway.ingress.path
            pathType = var.tempo.gateway.ingress.pathType
          }]
        }]
        tls = var.tempo.gateway.ingress.tls
      }
    }
    querier = {
      enabled      = var.tempo.querier.enabled
      replicas     = var.tempo.querier.replicas
      resources    = var.tempo.querier.resources
      nodeSelector = var.tempo.querier.nodeSelector
      tolerations  = var.tempo.querier.tolerations
    }
    traces = {
      otlp = {
        http = {
          enabled = var.tempo.traces.otlp.http.enabled
        }
        grpc = {
          enabled = var.tempo.traces.otlp.grpc.enabled
        }
      }
    }
    metricsGenerator = {
      enabled        = var.tempo.metricsGenerator.enabled
      remoteWriteUrl = var.tempo.metricsGenerator.remoteWriteUrl
      resources      = var.tempo.metricsGenerator.resources
      nodeSelector   = var.tempo.metricsGenerator.nodeSelector
      tolerations    = var.tempo.metricsGenerator.tolerations
    }
    overrides = {
      defaults = {
        metrics_generator = {
          processors = var.tempo.metricsGenerator.processors
        }
      }
    }
  }
}
