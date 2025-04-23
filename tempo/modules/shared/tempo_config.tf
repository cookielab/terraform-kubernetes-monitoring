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
    }
    gateway = {
      enabled   = var.tempo.gateway.enabled
      replicas  = var.tempo.gateway.replicas
      resources = var.tempo.gateway.resources
    }
    querier = {
      enabled   = var.tempo.querier.enabled
      replicas  = var.tempo.querier.replicas
      resources = var.tempo.querier.resources
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
