<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5, < 2.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.27.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 6.27.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tempo"></a> [tempo](#module\_tempo) | ../shared | n/a |
| <a name="module_tempo_gcs"></a> [tempo\_gcs](#module\_tempo\_gcs) | terraform-google-modules/cloud-storage/google | ~> 10.0 |

## Resources

| Name | Type |
|------|------|
| [google_project_iam_custom_role.gcs_rw_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_storage_bucket_iam_binding.gcs_rw_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_buckets"></a> [buckets](#input\_buckets) | List of buckets to create | `list(string)` | <pre>[<br/>  "traces"<br/>]</pre> | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The cloud provider to use (gcp, aws) | `string` | `"gcp"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy the tempo service to | `string` | `"monitoring"` | no |
| <a name="input_otel_collector"></a> [otel\_collector](#input\_otel\_collector) | The otel collector configuration | <pre>object({<br/>    name      = optional(string, "grafana-alloy-otel-collector")<br/>    namespace = optional(string, "monitoring")<br/>    port      = optional(number, 4317)<br/>  })</pre> | `{}` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_rw_bucket_roles"></a> [rw\_bucket\_roles](#input\_rw\_bucket\_roles) | List of roles that need read/write access to the buckets | `list(string)` | `[]` | no |
| <a name="input_storage_location"></a> [storage\_location](#input\_storage\_location) | The location of the storage bucket in GCP | `string` | n/a | yes |
| <a name="input_storage_prefix"></a> [storage\_prefix](#input\_storage\_prefix) | The prefix for the storage bucket | `string` | `""` | no |
| <a name="input_tempo"></a> [tempo](#input\_tempo) | The tempo configuration | <pre>object({<br/>    serviceAccount = optional(object({<br/>      name        = optional(string, "tempo")<br/>      create      = optional(bool, true)<br/>      annotations = optional(map(string), {})<br/>    }), {})<br/>    metricsGenerator = optional(object({<br/>      enabled        = optional(bool, true)<br/>      remoteWriteUrl = optional(string, "")<br/>      processors     = optional(list(string), ["service-graphs", "span-metrics"])<br/>    }), {})<br/>    ingester = optional(object({<br/>      replicas = optional(number, 2)<br/>      zoneAwareReplication = optional(object({<br/>        enabled = optional(bool, false)<br/>      }), {})<br/>    }), {})<br/>    gateway = optional(object({<br/>      enabled = optional(bool, true)<br/>    }), {})<br/>    querier = optional(object({<br/>      enabled = optional(bool, true)<br/>    }), {})<br/>    traces = optional(object({<br/>      otlp = optional(object({<br/>        http = optional(object({<br/>          enabled = optional(bool, true)<br/>        }), {})<br/>        grpc = optional(object({<br/>          enabled = optional(bool, true)<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    test_traces = optional(object({<br/>      enabled                    = optional(bool, false)<br/>      name                       = optional(string, "test-traces")<br/>      telemetrygen_image_version = optional(string, "v0.96.0")<br/>    }), {})<br/>  })</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
