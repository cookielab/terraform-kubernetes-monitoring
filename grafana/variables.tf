variable "grafana" {
  type = object({
    env = optional(object({
      GF_SERVER_ROOT_URL = optional(string, "")
    }), {})
    replicas = optional(number, 1)
    persistence = optional(object({
      enabled      = optional(bool, true)
      storageClass = optional(string, "")
      size         = optional(string, "10Gi")
      type         = optional(string, "pvc")
    }), {})
    resources = optional(object({
      requests = optional(object({
        cpu    = optional(string, "100m")
        memory = optional(string, "128Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string, "100m")
        memory = optional(string, "128Mi")
      }), {})
    }), {})
    serviceAccount = optional(object({
      create      = optional(bool, true)
      name        = optional(string, "grafana")
      annotations = optional(map(string), {})
    }), {})
    ingress = optional(object({
      enabled     = optional(bool, false)
      annotations = optional(map(string), {})
      hosts       = optional(list(string), [])
      path        = optional(string, "/")
      pathType    = optional(string, "ImplementationSpecific")
      tls = optional(list(object({
        secretName = optional(string, "grafana-tls")
        hosts      = optional(list(string), [""])
      })), [])
    }), {})
    plugins     = optional(list(string), [])
    datasources = optional(map(any), {})
    alerting    = optional(map(any), {})
    dashboards  = optional(map(any), {})
  })
  default     = {}
  description = "The grafana configuration"
}

variable "cloud_provider" {
  type        = string
  description = "The cloud provider to use"
}

variable "namespace" {
  type        = string
  default     = "monitoring"
  description = "The namespace to deploy the grafana to"
}

variable "grafana_helm_version" {
  type        = string
  default     = "8.11.0"
  description = "The version of the helm chart to use"
}

variable "helm_release_name" {
  type        = string
  default     = "grafana"
  description = "The name of the helm release to use"
}

