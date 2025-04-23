<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5, < 2.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 6.27 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_loki"></a> [loki](#module\_loki) | ../shared | n/a |
| <a name="module_loki_gcs"></a> [loki\_gcs](#module\_loki\_gcs) | terraform-google-modules/cloud-storage/google | ~> 10.0 |

## Resources

| Name | Type |
|------|------|
| [google_project_iam_custom_role.gcs_rw_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_storage_bucket_iam_binding.gcs_rw_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_buckets"></a> [buckets](#input\_buckets) | List of buckets to create | `list(string)` | <pre>[<br/>  "chunks"<br/>]</pre> | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The cloud provider to use (gcp, aws) | `string` | `"gcp"` | no |
| <a name="input_loki"></a> [loki](#input\_loki) | The Loki configuration | <pre>object({<br/>    serviceAccount = optional(object({<br/>      name        = optional(string, "loki")<br/>      create      = optional(bool, true)<br/>      annotations = optional(map(string), {})<br/>    }), {})<br/>    ruler = optional(object({<br/>      enabled  = optional(bool, false)<br/>      replicas = optional(number, 0)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    write = optional(object({<br/>      enabled  = optional(bool, true)<br/>      replicas = optional(number, 2)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "512Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "512Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    read = optional(object({<br/>      enabled  = optional(bool, true)<br/>      replicas = optional(number, 2)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    backend = optional(object({<br/>      enabled  = optional(bool, true)<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    gateway = optional(object({<br/>      enabled  = optional(bool, true)<br/>      replicas = optional(number, 1)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>    querier = optional(object({<br/>      enabled  = optional(bool, false)<br/>      replicas = optional(number, 0)<br/>      resources = optional(object({<br/>        requests = optional(object({<br/>          cpu    = optional(string, "100m")<br/>          memory = optional(string, "100Mi")<br/>        }), {})<br/>        limits = optional(object({<br/>          cpu    = optional(string, "200m")<br/>          memory = optional(string, "200Mi")<br/>        }), {})<br/>      }), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy the mimir service to | `string` | `"monitoring"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_rw_bucket_roles"></a> [rw\_bucket\_roles](#input\_rw\_bucket\_roles) | List of roles that need read/write access to the buckets | `list(string)` | `[]` | no |
| <a name="input_storage_location"></a> [storage\_location](#input\_storage\_location) | The location of the storage bucket in GCP | `string` | n/a | yes |
| <a name="input_storage_prefix"></a> [storage\_prefix](#input\_storage\_prefix) | The prefix for the storage bucket | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->