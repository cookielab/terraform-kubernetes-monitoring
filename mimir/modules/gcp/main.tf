locals {
  bucket_prefix = "mimir-"
}

module "mimir_gcs" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "~> 10.0"

  project_id = var.project_id
  location   = var.storage_location
  names      = ["${local.bucket_prefix}blocks", "${local.bucket_prefix}ruler", "${local.bucket_prefix}alertmanager"]
  prefix     = var.storage_prefix
}

resource "google_project_iam_custom_role" "gcs_rw_role" {
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

resource "google_storage_bucket_iam_binding" "gcs_rw_member" {
  for_each = toset(var.buckets)
  bucket   = "${var.storage_prefix}-${local.bucket_prefix}${each.key}"
  role     = google_project_iam_custom_role.gcs_rw_role.id
  members  = var.rw_bucket_roles
}

module "mimir" {
  source = "../shared"

  cloud_provider   = var.cloud_provider
  project_id       = var.project_id
  storage_location = var.storage_location
  custom_config    = var.custom_config
  rw_bucket_roles  = var.rw_bucket_roles
  storage_bucket_name = {
    for bucket in var.buckets :
    "${local.bucket_prefix}${bucket}" => module.mimir_gcs.names["${local.bucket_prefix}${bucket}"]
  }
}
