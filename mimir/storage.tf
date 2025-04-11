locals {
  bucket_prefix = "mimir-"
}

module "mimir_gcs" {
  count   = var.cloud_provider == "gcp" ? 1 : 0
  source  = "terraform-google-modules/cloud-storage/google"
  version = "~> 10.0"

  project_id = var.project_id
  location   = var.storage_location
  names      = ["${local.bucket_prefix}blocks", "${local.bucket_prefix}ruler", "${local.bucket_prefix}alertmanager"]
  prefix     = var.storage_prefix
  creators   = var.rw_bucket_roles
}

resource "google_project_iam_custom_role" "gcs_rw_role" {
  count       = var.cloud_provider == "gcp" ? 1 : 0
  role_id     = "mimir_gcs_rw_role"
  title       = "GCS Read Write Role"
  description = "A custom role for mimir to access GCS buckets"
  permissions = [
    "storage.objects.get",
    "storage.objects.list",
    "storage.objects.create",
    "storage.objects.delete",
  ]
  project = var.project_id
}

module "mimir_s3" {
  for_each = var.cloud_provider == "aws" ? toset(["blocks", "alertmanager", "ruler"]) : []

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.6.1"

  bucket = format("%s%s", local.bucket_prefix, each.key)

  acl                      = "private"
  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true
  block_public_acls                     = true
  block_public_policy                   = true
  ignore_public_acls                    = true
  restrict_public_buckets               = true
}

resource "aws_iam_policy" "mimir_s3" {
  name   = "AmazonS3ReadOnlyAccess"
  policy = data.aws_iam_policy_document.mimir_s3.json
}

data "aws_iam_policy_document" "mimir_s3" {
  statement {
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
      "s3:PutObject"
    ]

    resources = flatten([
      for k, v in module.mimir_s3 : [v.s3_bucket_arn, "${v.s3_bucket_arn}/*"]
    ])
  }
}

module "mimir_irsa" {
  count   = var.cloud_provider == "aws" ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.54.1"

  role_name_prefix = "${local.bucket_prefix}irsa"
  role_policy_arns = {
    s3_policy = aws_iam_policy.mimir_s3.arn
  }

  oidc_providers = {
    main = {
      provider_arn = var.oidc_provider_arn
      namespace_service_accounts = [format("%s:%s",
        var.namespace,
        local.mimir_service_account_name)
      ]
    }
  }
}
