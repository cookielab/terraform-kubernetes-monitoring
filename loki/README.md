# Loki Modules

This directory contains Terraform modules for deploying Grafana Loki backed by storage on different cloud providers.

## Structure

- `aws/` - AWS-specific implementation using S3 for storage
- `gcp/` - GCP-specific implementation using GCS for storage  
- `shared/` - Common Helm chart configuration shared between providers

## Variables

### Common Variables

- `namespace` - The namespace to deploy the loki service to
- `storage_prefix` - The prefix for the storage bucket
- `loki` - The loki configuration

### GCP Variables

- `project_id` - The GCP project ID
- `storage_location` - The GCP storage location
- `rw_bucket_roles` - The roles(serviceaccounts) for the read/write bucket

### AWS Variables

- `oidc_provider_arn` - The OIDC provider ARN

## Usage

### GCP Example

```hcl
module "loki" {
  source = "./loki/modules/gcp"

  project_id       = "project-id"
  storage_location = "europe-west1"
  storage_prefix   = "project-name"
  loki = {
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
  rw_bucket_roles = [
    "serviceAccount:project-id@project-id.iam.gserviceaccount.com",
  ]
}
```

### AWS Example

```hcl
module "loki" {
  source = "./modules/aws"

  oidc_provider_arn = "arn:aws:iam::xxx:oidc-provider/oidc.eks.eu-west-1.amazonaws.com/id/xxx"  
  namespace        = "monitoring"
  storage_prefix   = "project-name-"
}

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
