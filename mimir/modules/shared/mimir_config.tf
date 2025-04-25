locals {
  mimir_service_account_name = "mimir"
  bucket_prefix              = "mimir-"

  get_bucket_name = {
    ruler        = "${local.bucket_prefix}ruler"
    alertmanager = "${local.bucket_prefix}alertmanager"
    blocks       = "${local.bucket_prefix}blocks"
  }

  // Define a map of storage configurations for each context
  storage_configs = {
    blocks_storage = {
      gcp = {
        backend = "gcs"
        gcs = {
          bucket_name = "${var.storage_bucket_name["${local.bucket_prefix}blocks"]}"
        }
        s3 = {}
      }
      aws = {
        backend = "s3"
        gcs     = {}
        s3 = {
          bucket_name = "${var.storage_prefix}${var.storage_bucket_name["${local.bucket_prefix}blocks"]}"
        }
      }
    }
    ruler_storage = {
      gcp = {
        backend = "gcs"
        gcs = {
          bucket_name = "${var.storage_bucket_name["${local.bucket_prefix}ruler"]}"
        }
        s3 = {}
      }
      aws = {
        backend = "s3"
        gcs     = {}
        s3 = {
          bucket_name = "${var.storage_prefix}${var.storage_bucket_name["${local.bucket_prefix}ruler"]}"
        }
      }
    }
    alertmanager_storage = {
      gcp = {
        backend = "gcs"
        gcs = {
          bucket_name = "${var.storage_bucket_name["${local.bucket_prefix}alertmanager"]}"
        }
        s3 = {}
      }
      aws = {
        backend = "s3"
        gcs     = {}
        s3 = {
          bucket_name = "${var.storage_prefix}${var.storage_bucket_name["${local.bucket_prefix}alertmanager"]}"
        }
      }
    }
  }

  mimir_config = merge(
    {
      minio = {
        enabled = false
      }
      serviceAccount = {
        name        = local.mimir_service_account_name
        create      = true
        annotations = var.mimir.serviceAccount.annotations
      }
      mimir = {
        structuredConfig = merge(
          {
            common = {
              storage = {
                backend = var.cloud_provider == "gcp" ? "gcs" : var.cloud_provider == "aws" ? "s3" : ""
                s3 = var.cloud_provider == "aws" ? {
                  endpoint = "s3.amazonaws.com"
                  region   = var.aws_region
                } : {}
              }
            }
          },
          { for key, value in local.storage_configs :
            key => {
              backend = var.cloud_provider == "gcp" ? value.gcp.backend : var.cloud_provider == "aws" ? value.aws.backend : ""
              gcs     = var.cloud_provider == "gcp" ? value.gcp.gcs : {}
              s3      = var.cloud_provider == "aws" ? value.aws.s3 : {}
            }
          }
        )
      }
      runtimeConfig = var.mimir.runtimeConfig
      ingester = {
        replicas             = var.mimir.ingester.replicas
        zoneAwareReplication = var.mimir.ingester.zoneAwareReplication
        resources            = var.mimir.ingester.resources
      }
      store_gateway = {
        replicas             = var.mimir.store_gateway.replicas
        zoneAwareReplication = var.mimir.store_gateway.zoneAwareReplication
        resources            = var.mimir.store_gateway.resources
      }
      querier = {
        replicas  = var.mimir.querier.replicas
        resources = var.mimir.querier.resources
      }
      ruler = {
        replicas  = var.mimir.ruler.replicas
        resources = var.mimir.ruler.resources
      }
      compactor = {
        replicas  = var.mimir.compactor.replicas
        resources = var.mimir.compactor.resources
      }
      alertmanager = {
        replicas  = var.mimir.alertmanager.replicas
        resources = var.mimir.alertmanager.resources
      }
      distributor = {
        replicas  = var.mimir.distributor.replicas
        resources = var.mimir.distributor.resources
      }
    }
  )
}

