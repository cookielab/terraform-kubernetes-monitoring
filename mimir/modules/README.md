# Mimir Modules

This directory contains Terraform modules for deploying Grafana Mimir backed by storage on different cloud providers.

## Structure

- `aws/` - AWS-specific implementation using S3 for storage
- `gcp/` - GCP-specific implementation using GCS for storage  
- `shared/` - Common Helm chart configuration shared between providers

## Variables

### GCP Variables

- `project_id` - The GCP project ID
- `storage_location` - The GCP storage location
- `storage_prefix` - The prefix for the storage bucket
- `custom_config` - The custom configuration for the mimir service

### AWS Variables


## Usage

### GCP Example

```hcl
module "mimir" {
  source = "./mimir/modules/gcp"

  project_id       = "project-id"
  storage_location = "europe-west1"
  storage_prefix   = "project-name"
  custom_config = {
    mimir = {
      ingester = {
        replicas = 1
        zoneAwareReplication = {
          enabled = false
        }
      }
      store_gateway = {
        replicas = 1
        zoneAwareReplication = {
          enabled = false
        }
      }
    }
  }
  rw_bucket_roles = [
    "serviceAccount:project-id@project-id.iam.gserviceaccount.com",
  ]
}
```

### AWS Example

```hcl
module "mimir" {
  source = "./mimir/modules/aws"

  bucket_name = "mimir-bucket"
  bucket_arn = "arn:aws:s3:::mimir-bucket"
}
