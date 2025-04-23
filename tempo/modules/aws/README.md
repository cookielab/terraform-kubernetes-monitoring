<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5, < 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.94 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.94 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tempo"></a> [tempo](#module\_tempo) | ../shared | n/a |
| <a name="module_tempo_irsa"></a> [tempo\_irsa](#module\_tempo\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.54.1 |
| <a name="module_tempo_s3"></a> [tempo\_s3](#module\_tempo\_s3) | terraform-aws-modules/s3-bucket/aws | 4.6.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.tempo_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_document.tempo_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_buckets"></a> [buckets](#input\_buckets) | List of buckets to create | `list(string)` | <pre>[<br/>  "traces"<br/>]</pre> | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The cloud provider to use (gcp, aws) | `string` | `"aws"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy the tempo service to | `string` | `"monitoring"` | no |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | The OIDC provider ARN | `string` | n/a | yes |
| <a name="input_otel_collector"></a> [otel\_collector](#input\_otel\_collector) | The otel collector configuration | <pre>object({<br/>    name      = optional(string, "grafana-alloy-otel-collector")<br/>    namespace = optional(string, "monitoring")<br/>    port      = optional(number, 4317)<br/>  })</pre> | `{}` | no |
| <a name="input_rw_bucket_roles"></a> [rw\_bucket\_roles](#input\_rw\_bucket\_roles) | List of roles that need read/write access to the buckets | `list(string)` | `[]` | no |
| <a name="input_storage_prefix"></a> [storage\_prefix](#input\_storage\_prefix) | n/a | `string` | `""` | no |
| <a name="input_tempo"></a> [tempo](#input\_tempo) | The tempo configuration | <pre>object({<br/>    serviceAccount = optional(object({<br/>      name        = optional(string, "tempo")<br/>      create      = optional(bool, true)<br/>      annotations = optional(map(string), {})<br/>    }), {})<br/>    metricsGenerator = optional(object({<br/>      enabled        = optional(bool, true)<br/>      remoteWriteUrl = optional(string, "")<br/>      processors     = optional(list(string), ["service-graphs", "span-metrics"])<br/>    }), {})<br/>    ingester = optional(object({<br/>      replicas = optional(number, 2)<br/>      zoneAwareReplication = optional(object({<br/>        enabled = optional(bool, false)<br/>      }), {})<br/>    }), {})<br/>    gateway = optional(object({<br/>      enabled = optional(bool, true)<br/>    }), {})<br/>    querier = optional(object({<br/>      enabled = optional(bool, true)<br/>    }), {})<br/>    traces = optional(object({<br/>      otlp = optional(object({<br/>        http = optional(object({<br/>          enabled = optional(bool, true)<br/>        }), {})<br/>        grpc = optional(object({<br/>          enabled = optional(bool, true)<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    test_traces = optional(object({<br/>      enabled                    = optional(bool, false)<br/>      name                       = optional(string, "test-traces")<br/>      telemetrygen_image_version = optional(string, "v0.96.0")<br/>    }), {})<br/>  })</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->