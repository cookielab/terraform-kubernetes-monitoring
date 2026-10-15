locals {
  bucket_name = "${var.storage_prefix}pyroscope-profiles"
}

module "pyroscope_s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.6.1"

  bucket = local.bucket_name

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

resource "aws_iam_policy" "pyroscope_s3" {
  name   = "${local.bucket_name}-AmazonS3ReadWriteAccess"
  policy = data.aws_iam_policy_document.pyroscope_s3.json
}

data "aws_iam_policy_document" "pyroscope_s3" {
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

    resources = [module.pyroscope_s3.s3_bucket_arn, "${module.pyroscope_s3.s3_bucket_arn}/*"]
  }
}

module "pyroscope_irsa" {
  count   = var.use_pod_identity ? 0 : 1
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.54.1"

  role_name_prefix = "${local.bucket_name}-irsa"
  role_policy_arns = {
    s3_policy = aws_iam_policy.pyroscope_s3.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${var.namespace}:${var.pyroscope.serviceAccount.name}"]
    }
  }
}

resource "aws_iam_role" "pyroscope_pod_identity" {
  count       = var.use_pod_identity ? 1 : 0
  name_prefix = "${local.bucket_name}-pod-identity-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "pods.eks.amazonaws.com" }
      Action    = ["sts:AssumeRole", "sts:TagSession"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "pyroscope_pod_identity" {
  count      = var.use_pod_identity ? 1 : 0
  role       = aws_iam_role.pyroscope_pod_identity[0].name
  policy_arn = aws_iam_policy.pyroscope_s3.arn
}

resource "aws_eks_pod_identity_association" "pyroscope" {
  count           = var.use_pod_identity ? 1 : 0
  cluster_name    = var.cluster_name
  namespace       = var.namespace
  service_account = var.pyroscope.serviceAccount.name
  role_arn        = aws_iam_role.pyroscope_pod_identity[0].arn
}

module "pyroscope" {
  source = "../shared"

  namespace              = var.namespace
  helm_release_name      = var.helm_release_name
  pyroscope_helm_version = var.pyroscope_helm_version
  storage = {
    backend = "s3"
    s3 = {
      bucket_name = module.pyroscope_s3.s3_bucket_id
      endpoint    = var.use_vpc_endpoint ? "s3.${var.aws_region}.amazonaws.com" : "s3.amazonaws.com"
      region      = var.aws_region
    }
  }
  pyroscope = merge(var.pyroscope, {
    serviceAccount = merge(var.pyroscope.serviceAccount, {
      annotations = var.use_pod_identity ? var.pyroscope.serviceAccount.annotations : merge(
        var.pyroscope.serviceAccount.annotations,
        { "eks.amazonaws.com/role-arn" = module.pyroscope_irsa[0].iam_role_arn }
      )
    })
  })
  pyroscope_extra = var.pyroscope_extra
}
