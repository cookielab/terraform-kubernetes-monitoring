variable "namespace" {
  type        = string
  description = "The namespace to deploy the pyroscope service to"
  default     = "monitoring"
}

variable "pyroscope_helm_version" {
  type        = string
  description = "The version of the pyroscope helm chart to use"
  default     = "2.4.0"
}

variable "helm_release_name" {
  type        = string
  description = "The name of the helm release to use"
  default     = "pyroscope"
}

variable "storage" {
  type        = any
  description = "Pyroscope object storage config (`storage` block of the Pyroscope config), built by the cloud-specific module"
}

variable "pyroscope" {
  type = object({
    multitenancyEnabled = optional(bool, false)
    serviceAccount = optional(object({
      name        = optional(string, "pyroscope")
      create      = optional(bool, true)
      annotations = optional(map(string), {})
    }), {})
    metastore = optional(object({
      persistence = optional(object({
        enabled          = optional(bool, true)
        size             = optional(string, "10Gi")
        storageClassName = optional(string)
      }), {})
    }), {})
    ingress = optional(object({
      enabled     = optional(bool, false)
      className   = optional(string, "")
      annotations = optional(map(string), {})
      hosts       = optional(list(string), [])
      pathType    = optional(string, "Prefix")
      tls = optional(list(object({
        secretName = optional(string)
        hosts      = optional(list(string))
      })), [])
    }), {})
    gateway = optional(object({
      enabled  = optional(bool, false)
      replicas = optional(number, 2)
      image    = optional(string, "docker.io/nginxinc/nginx-unprivileged:1.29-alpine")
      resources = optional(object({
        requests = optional(map(string), { cpu = "50m", memory = "64Mi" })
        limits   = optional(map(string), { memory = "128Mi" })
      }), {})
      basicAuth = optional(object({
        existingSecret = optional(string)
      }), {})
    }), {})
    nodeSelector = optional(map(string), {})
    tolerations = optional(list(object({
      key               = optional(string)
      operator          = optional(string)
      value             = optional(string)
      effect            = optional(string)
      tolerationSeconds = optional(number)
    })), [])
  })
  description = "The Pyroscope configuration"
  default     = {}
}

variable "pyroscope_extra" {
  type        = any
  description = "Additional Helm values for pyroscope chart, merged after the generated config (e.g. per-component replicas/resources under pyroscope.components)"
  default     = {}
}
