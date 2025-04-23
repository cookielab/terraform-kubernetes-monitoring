<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5, < 2.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.17.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.36.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.17.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.36.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.tempo](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.test_traces_cronjob](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The cloud provider to use (gcp, aws) | `string` | n/a | yes |
| <a name="input_helm_release_name"></a> [helm\_release\_name](#input\_helm\_release\_name) | The name of the helm release to use | `string` | `"tempo"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy the tempo service to | `string` | `"monitoring"` | no |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | The OIDC provider ARN | `string` | `""` | no |
| <a name="input_otel_collector"></a> [otel\_collector](#input\_otel\_collector) | The otel collector configuration | <pre>object({<br/>    name      = optional(string, "grafana-alloy-otel-collector")<br/>    namespace = optional(string, "monitoring")<br/>    port      = optional(number, 4317)<br/>  })</pre> | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | `""` | no |
| <a name="input_rw_bucket_roles"></a> [rw\_bucket\_roles](#input\_rw\_bucket\_roles) | List of roles that need read/write access to the buckets | `list(string)` | `[]` | no |
| <a name="input_storage_bucket_name"></a> [storage\_bucket\_name](#input\_storage\_bucket\_name) | The name of the storage bucket | `map(string)` | `{}` | no |
| <a name="input_storage_location"></a> [storage\_location](#input\_storage\_location) | The location of the storage bucket (for GCP) | `string` | `"europe-west1"` | no |
| <a name="input_storage_prefix"></a> [storage\_prefix](#input\_storage\_prefix) | The prefix for the storage bucket | `string` | `""` | no |
| <a name="input_tempo"></a> [tempo](#input\_tempo) | The tempo configuration | <pre>object({<br/>    serviceAccount = optional(object({<br/>      name        = optional(string, "tempo")<br/>      create      = optional(bool, true)<br/>      annotations = optional(map(string), {})<br/>    }), {})<br/>    metricsGenerator = optional(object({<br/>      enabled        = optional(bool, true)<br/>      remoteWriteUrl = optional(string, "")<br/>      processors     = optional(list(string), ["service-graphs", "span-metrics"])<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    ingester = optional(object({<br/>      replicas = optional(number, 2)<br/>      zoneAwareReplication = optional(object({<br/>        enabled = optional(bool, false)<br/>      }), {})<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "256Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "256Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    gateway = optional(object({<br/>      enabled  = optional(bool, true)<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    querier = optional(object({<br/>      enabled  = optional(bool, true)<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    traces = optional(object({<br/>      otlp = optional(object({<br/>        http = optional(object({<br/>          enabled = optional(bool, true)<br/>        }), {})<br/>        grpc = optional(object({<br/>          enabled = optional(bool, true)<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    test_traces = optional(object({<br/>      enabled                    = optional(bool, false)<br/>      name                       = optional(string, "test-traces")<br/>      telemetrygen_image_version = optional(string, "v0.96.0")<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_tempo_helm_version"></a> [tempo\_helm\_version](#input\_tempo\_helm\_version) | The version of the tempo helm chart to use | `string` | `"1.34.0"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
