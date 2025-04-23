<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5, < 2.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.mimir](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"eu-west-1"` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The cloud provider to use (gcp, aws) | `string` | n/a | yes |
| <a name="input_helm_release_name"></a> [helm\_release\_name](#input\_helm\_release\_name) | The name of the helm release to use | `string` | `"mimir"` | no |
| <a name="input_mimir"></a> [mimir](#input\_mimir) | The mimir configuration | <pre>object({<br/>    serviceAccount = optional(object({<br/>      name        = optional(string, "mimir")<br/>      create      = optional(bool, true)<br/>      annotations = optional(map(string), {})<br/>    }), {})<br/>    ingester = optional(object({<br/>      replicas = optional(number, 2)<br/>      zoneAwareReplication = optional(object({<br/>        enabled = optional(bool, false)<br/>      }), {})<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "512Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "512Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    store_gateway = optional(object({<br/>      replicas = optional(number, 1)<br/>      zoneAwareReplication = optional(object({<br/>        enabled = optional(bool, false)<br/>      }), {})<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    querier = optional(object({<br/>      replicas = optional(number, 2)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    ruler = optional(object({<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    compactor = optional(object({<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    alertmanager = optional(object({<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    distributor = optional(object({<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_mimir_helm_version"></a> [mimir\_helm\_version](#input\_mimir\_helm\_version) | The version of the mimir helm chart to use | `string` | `"5.8.0-weekly.335"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy the mimir service to | `string` | `"monitoring"` | no |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | The OIDC provider ARN | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | `""` | no |
| <a name="input_rw_bucket_roles"></a> [rw\_bucket\_roles](#input\_rw\_bucket\_roles) | List of roles that need read/write access to the buckets | `list(string)` | `[]` | no |
| <a name="input_storage_bucket_name"></a> [storage\_bucket\_name](#input\_storage\_bucket\_name) | The name of the storage bucket | `map(string)` | `{}` | no |
| <a name="input_storage_location"></a> [storage\_location](#input\_storage\_location) | The location of the storage bucket (for GCP) | `string` | `"europe-west1"` | no |
| <a name="input_storage_prefix"></a> [storage\_prefix](#input\_storage\_prefix) | The prefix for the storage bucket | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->