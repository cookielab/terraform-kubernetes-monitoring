locals {
  mimir_service_account_name = "mimir"
  bucket_prefix              = "mimir-"
  mimir_config = merge(
    {
      serviceAccount = {
        name   = local.mimir_service_account_name
        create = true
      }
      mimir = {
        structuredConfig = {
          blocks_storage = var.cloud_provider == "gcp" ? {
            backend = "gcs"
            gcs = {
              bucket_name = var.storage_bucket_name["${local.bucket_prefix}blocks"]
            }
            } : var.cloud_provider == "aws" ? {
            backend = "s3"
            s3 = {
              bucket_name = var.storage_bucket_name["${local.bucket_prefix}blocks"]
            }
          } : {}
          ruler_storage = var.cloud_provider == "gcp" ? {
            backend = "gcs"
            gcs = {
              bucket_name = var.storage_bucket_name["${local.bucket_prefix}ruler"]
            }
            } : var.cloud_provider == "aws" ? {
            backend = "s3"
            s3 = {
              bucket_name = var.storage_bucket_name["${local.bucket_prefix}ruler"]
            }
          } : {}
          alertmanager_storage = var.cloud_provider == "gcp" ? {
            backend = "gcs"
            gcs = {
              bucket_name = var.storage_bucket_name["${local.bucket_prefix}alertmanager"]
            }
            } : var.cloud_provider == "aws" ? {
            backend = "s3"
            s3 = {
              bucket_name = var.storage_bucket_name["${local.bucket_prefix}alertmanager"]
            }
          } : {}

        }
      }
    },
    var.custom_config
  )
}
