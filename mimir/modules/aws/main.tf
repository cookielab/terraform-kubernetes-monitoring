locals {
  bucket_prefix              = "mimir-"
  mimir_service_account_name = "mimir"
}

module "mimir_s3" {
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

resource "aws_iam_policy" "mimir_s3" {
  name   = "${var.storage_prefix}${local.bucket_prefix}AmazonS3ReadWriteAccess"
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
      "s3:PutObject",
      "s3:ListObjects"
    ]

    resources = flatten([
      for k, v in module.mimir_s3 : [v.s3_bucket_arn, "${v.s3_bucket_arn}/*"]
    ])
  }
}

module "mimir_irsa" {
  count   = var.use_pod_identity ? 0 : 1
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.54.1"

  role_name_prefix = "${var.storage_prefix}${local.bucket_prefix}irsa"
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

resource "aws_iam_role" "mimir_pod_identity" {
  count       = var.use_pod_identity ? 1 : 0
  name_prefix = "${var.storage_prefix}${local.bucket_prefix}pod-identity-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "pods.eks.amazonaws.com" }
      Action    = ["sts:AssumeRole", "sts:TagSession"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "mimir_pod_identity" {
  count      = var.use_pod_identity ? 1 : 0
  role       = aws_iam_role.mimir_pod_identity[0].name
  policy_arn = aws_iam_policy.mimir_s3.arn
}

resource "aws_eks_pod_identity_association" "mimir" {
  count           = var.use_pod_identity ? 1 : 0
  cluster_name    = var.cluster_name
  namespace       = var.namespace
  service_account = local.mimir_service_account_name
  role_arn        = aws_iam_role.mimir_pod_identity[0].arn
}

module "mimir" {
  source = "../shared"

  cloud_provider = var.cloud_provider
  namespace      = var.namespace
  storage_prefix = var.storage_prefix
  aws_region     = var.aws_region
  mimir = {
    serviceAccount = {
      annotations = var.use_pod_identity ? {} : {
        "eks.amazonaws.com/role-arn" = module.mimir_irsa[0].iam_role_arn
      }
    }
  }
  storage_bucket_name = {
    for bucket in var.buckets :
    "${local.bucket_prefix}${bucket}" => "${local.bucket_prefix}${bucket}"
  }
}
