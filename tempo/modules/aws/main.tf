locals {
  bucket_prefix              = "tempo-"
  tempo_service_account_name = "tempo"
}

module "tempo_s3" {
  for_each = toset(var.buckets)

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.6.1"

  bucket = format("%s%s%s", var.storage_prefix, local.bucket_prefix, each.key)

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

resource "aws_iam_policy" "tempo_s3" {
  name   = "${var.storage_prefix}${local.bucket_prefix}AmazonS3ReadOnlyAccess"
  policy = data.aws_iam_policy_document.tempo_s3.json
}

data "aws_iam_policy_document" "tempo_s3" {
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
      for k, v in module.tempo_s3 : [v.s3_bucket_arn, "${v.s3_bucket_arn}/*"]
    ])
  }
}

module "tempo_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.54.1"

  role_name_prefix = "${var.storage_prefix}${local.bucket_prefix}irsa"
  role_policy_arns = {
    s3_policy = aws_iam_policy.tempo_s3.arn
  }

  oidc_providers = {
    main = {
      provider_arn = var.oidc_provider_arn
      namespace_service_accounts = [format("%s:%s",
        var.namespace,
        local.tempo_service_account_name)
      ]
    }
  }
}

module "tempo" {
  source = "../shared"

  cloud_provider = var.cloud_provider
  namespace      = var.namespace
  otel_collector = var.otel_collector
  storage_prefix = var.storage_prefix
  tempo = {
    serviceAccount = {
      annotations = {
        "eks.amazonaws.com/role-arn" = module.tempo_irsa.iam_role_arn
      }
    }
  }
  storage_bucket_name = {
    for bucket in var.buckets :
    "${local.bucket_prefix}${bucket}" => "${local.bucket_prefix}${bucket}"
  }
}
