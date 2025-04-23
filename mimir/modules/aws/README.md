<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5, < 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.94.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.94.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mimir"></a> [mimir](#module\_mimir) | ../shared | n/a |
| <a name="module_mimir_irsa"></a> [mimir\_irsa](#module\_mimir\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.54.1 |
| <a name="module_mimir_s3"></a> [mimir\_s3](#module\_mimir\_s3) | terraform-aws-modules/s3-bucket/aws | 4.6.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.mimir_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_document.mimir_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to use | `string` | `"eu-west-1"` | no |
| <a name="input_buckets"></a> [buckets](#input\_buckets) | List of buckets to create | `list(string)` | <pre>[<br/>  "blocks",<br/>  "alertmanager",<br/>  "ruler"<br/>]</pre> | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The cloud provider to use (gcp, aws) | `string` | `"aws"` | no |
| <a name="input_mimir"></a> [mimir](#input\_mimir) | The mimir configuration | <pre>object({<br/>    serviceAccount = optional(object({<br/>      name        = optional(string, "mimir")<br/>      create      = optional(bool, true)<br/>      annotations = optional(map(string), {})<br/>    }), {})<br/>    ingester = optional(object({<br/>      replicas = optional(number, 2)<br/>      zoneAwareReplication = optional(object({<br/>        enabled = optional(bool, false)<br/>      }), {})<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "512Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "512Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    store_gateway = optional(object({<br/>      replicas = optional(number, 1)<br/>      zoneAwareReplication = optional(object({<br/>        enabled = optional(bool, true)<br/>      }), {})<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    querier = optional(object({<br/>      replicas = optional(number, 2)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    ruler = optional(object({<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    compactor = optional(object({<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    alertmanager = optional(object({<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    distributor = optional(object({<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy the mimir service account to | `string` | `"monitoring"` | no |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | The OIDC provider ARN | `string` | n/a | yes |
| <a name="input_storage_prefix"></a> [storage\_prefix](#input\_storage\_prefix) | The prefix for the storage bucket | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->