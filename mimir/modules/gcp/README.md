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
| <a name="module_mimir"></a> [mimir](#module\_mimir) | ../shared | n/a |
| <a name="module_mimir_gcs"></a> [mimir\_gcs](#module\_mimir\_gcs) | terraform-google-modules/cloud-storage/google | ~> 10.0 |

## Resources

| Name | Type |
|------|------|
| [google_project_iam_custom_role.gcs_rw_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_storage_bucket_iam_binding.gcs_rw_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_buckets"></a> [buckets](#input\_buckets) | List of buckets to create | `list(string)` | <pre>[<br/>  "blocks",<br/>  "alertmanager",<br/>  "ruler"<br/>]</pre> | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The cloud provider to use (gcp, aws) | `string` | `"gcp"` | no |
| <a name="input_mimir"></a> [mimir](#input\_mimir) | The mimir configuration | <pre>object({<br/>    serviceAccount = optional(object({<br/>      name        = optional(string, "mimir")<br/>      create      = optional(bool, true)<br/>      annotations = optional(map(string), {})<br/>    }), {})<br/>    ingester = optional(object({<br/>      replicas = optional(number, 2)<br/>      zoneAwareReplication = optional(object({<br/>        enabled = optional(bool, false)<br/>      }), {})<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "512Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "512Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    store_gateway = optional(object({<br/>      replicas = optional(number, 1)<br/>      zoneAwareReplication = optional(object({<br/>        enabled = optional(bool, true)<br/>      }), {})<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    querier = optional(object({<br/>      replicas = optional(number, 2)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    ruler = optional(object({<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    compactor = optional(object({<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    alertmanager = optional(object({<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    distributor = optional(object({<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy the mimir service to | `string` | `"monitoring"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_rw_bucket_roles"></a> [rw\_bucket\_roles](#input\_rw\_bucket\_roles) | List of roles that need read/write access to the buckets | `list(string)` | `[]` | no |
| <a name="input_storage_location"></a> [storage\_location](#input\_storage\_location) | The location of the storage bucket in GCP | `string` | n/a | yes |
| <a name="input_storage_prefix"></a> [storage\_prefix](#input\_storage\_prefix) | The prefix for the storage bucket | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->