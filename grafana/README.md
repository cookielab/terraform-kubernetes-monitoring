# Grafana Module

This module is used to deploy Grafana to visualize data from Prometheus, Loki, Mimir and Tempo.

## Variables

### Common Variables

- `namespace` - The namespace to deploy the grafana to
- `grafana` - The grafana configuration


## Usage

```hcl
module "grafana" {
  source    = "./"
  namespace = "monitoring"

  cloud_provider = "gcp"
  grafana = {
    replicas = 2
    env = {
      GF_SERVER_ROOT_URL = "https://example.com"
    }
    persistence = {
      enabled = true
    }
    ingress = {
      enabled = true
      annotations = {
        "kubernetes.io/ingress.class"    = "nginx"
        "cert-manager.io/cluster-issuer" = "letsencrypt-nginx"
      }
      hosts = [
        "example.com"
      ]
      path     = "/"
      pathType = "ImplementationSpecific"
      tls = [
        {
          secretName = "grafana-tls"
          hosts = [
            "example.com"
          ]
        }
      ]
    }
  }
}
```

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
| [helm_release.grafana](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The cloud provider to use | `string` | n/a | yes |
| <a name="input_grafana"></a> [grafana](#input\_grafana) | The grafana configuration | <pre>object({<br/>    env = optional(object({<br/>      GF_SERVER_ROOT_URL = optional(string, "")<br/>    }), {})<br/>    replicas = optional(number, 1)<br/>    persistence = optional(object({<br/>      enabled      = optional(bool, true)<br/>      storageClass = optional(string, "")<br/>      size         = optional(string, "10Gi")<br/>      type         = optional(string, "pvc")<br/>    }), {})<br/>    resources = optional(object({<br/>      requests = optional(object({<br/>        cpu    = optional(string, "100m")<br/>        memory = optional(string, "128Mi")<br/>      }), {})<br/>      limits = optional(object({<br/>        cpu    = optional(string, "100m")<br/>        memory = optional(string, "128Mi")<br/>      }), {})<br/>    }), {})<br/>    serviceAccount = optional(object({<br/>      create      = optional(bool, true)<br/>      name        = optional(string, "grafana")<br/>      annotations = optional(map(string), {})<br/>    }), {})<br/>    ingress = optional(object({<br/>      enabled     = optional(bool, false)<br/>      annotations = optional(map(string), {})<br/>      hosts       = optional(list(string), [])<br/>      path        = optional(string, "/")<br/>      pathType    = optional(string, "ImplementationSpecific")<br/>      tls = optional(list(object({<br/>        secretName = optional(string, "grafana-tls")<br/>        hosts      = optional(list(string), [""])<br/>      })), [])<br/>    }), {})<br/>    plugins     = optional(list(string), [])<br/>    datasources = optional(map(any), {})<br/>    alerting    = optional(map(any), {})<br/>    dashboards  = optional(map(any), {})<br/>  })</pre> | `{}` | no |
| <a name="input_grafana_helm_version"></a> [grafana\_helm\_version](#input\_grafana\_helm\_version) | The version of the helm chart to use | `string` | `"8.11.0"` | no |
| <a name="input_helm_release_name"></a> [helm\_release\_name](#input\_helm\_release\_name) | The name of the helm release to use | `string` | `"grafana"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy the grafana to | `string` | `"monitoring"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
