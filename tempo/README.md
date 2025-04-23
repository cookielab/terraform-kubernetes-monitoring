# Tempo Modules

This directory contains Terraform modules for deploying Tempo backed by storage on different cloud providers.

## Structure

- `aws/` - AWS-specific implementation using S3 for storage
- `gcp/` - GCP-specific implementation using GCS for storage  
- `shared/` - Common Helm chart configuration shared between providers

## Variables

### Common Variables

- `namespace` - The namespace to deploy the Tempo service to
- `storage_prefix` - The prefix for the storage bucket
- `tempo` - The Tempo configuration
  - `test_traces` - If enabled, a test traces cronjob will be created in the namespace
    - It needs a `otel_collector` configuration to be set => can be deployed via https://github.com/cookielab/terraform-kubernetes-grafana-alloy/tree/main/modules/otel-collector
  - `ingester` - The ingester configuration
    - `replicas` - The number of ingester replicas to deploy
    - `zoneAwareReplication` - The zone aware replication configuration
  - `gateway` - The gateway configuration
    - `enabled` - If enabled, a gateway will be deployed
  - `metricsGenerator` - The metrics generator configuration
    - `enabled` - If enabled, a metrics generator will be deployed
    - `remoteWriteUrl` - The remote write URL to send the metrics to
### GCP Variables

- `project_id` - The GCP project ID
- `storage_location` - The GCP storage location
- `rw_bucket_roles` - The roles(serviceaccounts) for the read/write bucket

### AWS Variables

- `oidc_provider_arn` - The OIDC provider ARN

## Usage

### GCP Example

```hcl
module "tempo" {
  source = "./modules/tempo/modules/gcp"

  project_id       = "project-id"
  storage_location = "europe-west1"
  storage_prefix   = "project-name"
  namespace        = "monitoring"
  rw_bucket_roles = [
    "serviceAccount:project-id@project-id.iam.gserviceaccount.com",
  ]
  otel_collector = {
    name      = "grafana-alloy-otel-collector"
    namespace = "monitoring"
    port      = 4317
  }


  tempo = {
    test_traces = {
      enabled = true
    }
    ingester = {
      replicas = 3
      zoneAwareReplication = {
        enabled = false
      }
    }
    gateway = {
      enabled = true
    }
    metricsGenerator = {
      enabled        = true
      remoteWriteUrl = "http://${local.metrics_endpoint_url}/api/v1/write"
    }
  }
}
```

### AWS Example

```hcl
module "tempo" {
  source = "./modules/aws"

  oidc_provider_arn = "arn:aws:iam::xxx:oidc-provider/oidc.eks.eu-west-1.amazonaws.com/id/xxx"  
  namespace        = "monitoring"
  storage_prefix   = "project-name-"
  tempo = {
    test_traces = {
      enabled = true
      name = "test-traces"
    }
  }
}
```

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
