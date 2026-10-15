# Pyroscope Modules

This directory contains Terraform modules for deploying Grafana Pyroscope (continuous profiling) in microservices mode, backed by object storage.

## Structure

- `aws/` - AWS-specific implementation using S3 for storage (IRSA or EKS Pod Identity)
- `shared/` - Common Helm chart configuration

## Variables

### Common Variables

- `namespace` - The namespace to deploy Pyroscope to
- `pyroscope` - The Pyroscope configuration
  - `multitenancyEnabled` - Require `X-Scope-OrgID` header on push and query
  - `serviceAccount` - Service account shared by all components
  - `metastore.persistence` - PVC for the v2 metastore raft log (enabled by default, `10Gi`)
  - `ingress` - Ingress routing UI/query paths to `query-frontend` and push paths to `distributor`
  - `nodeSelector` - Node selector labels applied to all components (default: `{}`)
  - `tolerations` - Tolerations applied to all components (default: `[]`)
- `pyroscope_extra` - Raw Helm values merged after the generated config, e.g. per-component replicas/resources under `pyroscope.components.<name>`

### AWS Variables

- `storage_prefix` - Prefix for the S3 bucket (`<prefix>pyroscope-profiles`) and IAM names
- `aws_region` - The AWS region
- `use_pod_identity` / `cluster_name` - Use EKS Pod Identity instead of IRSA
- `oidc_provider_arn` - Required for IRSA
- `use_vpc_endpoint` - Use the regional S3 endpoint

## Outputs

- `pyroscope_url` - Query URL (ingress if enabled, otherwise `query-frontend` service)
- `pyroscope_write_url` - In-cluster push URL (`distributor` service), for Alloy `pyroscope.write`

The chart's bundled Alloy is disabled; collect profiles with https://github.com/cookielab/terraform-kubernetes-grafana-alloy.
