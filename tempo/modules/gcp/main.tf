locals {
  bucket_prefix = "tempo-"
}

module "tempo_gcs" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "~> 10.0"

  project_id = var.project_id
  location   = var.storage_location
  names      = [for bucket in var.buckets : "${local.bucket_prefix}${bucket}"]
  prefix     = var.storage_prefix
}

resource "google_project_iam_custom_role" "gcs_rw_role" {
  role_id     = "tempo_gcs_rw_role"
  title       = "Tempo GCS Read Write Role"
  description = "A custom role for tempo to access GCS buckets"
  permissions = [
    "storage.objects.get",
    "storage.objects.list",
    "storage.objects.create",
    "storage.objects.delete",
    "storage.buckets.get"
  ]
  project = var.project_id
}

resource "google_storage_bucket_iam_binding" "gcs_rw_member" {
  for_each = toset(var.buckets)
  bucket   = "${var.storage_prefix}-${local.bucket_prefix}${each.key}"
  role     = google_project_iam_custom_role.gcs_rw_role.id
  members  = var.rw_bucket_roles
}

module "tempo" {
  source = "../shared"

  cloud_provider   = var.cloud_provider
  project_id       = var.project_id
  storage_location = var.storage_location
  rw_bucket_roles  = var.rw_bucket_roles
  otel_collector   = var.otel_collector
  tempo            = var.tempo
  namespace        = var.namespace
  storage_bucket_name = {
    for bucket in var.buckets :
    "${local.bucket_prefix}${bucket}" => module.tempo_gcs.names["${local.bucket_prefix}${bucket}"]
  }
}
