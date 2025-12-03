locals {
  grafana_config = {
    replicas      = var.grafana.replicas
    envFromSecret = var.grafana.envFromSecret
    env           = var.grafana.env
    persistence = {
      enabled      = var.grafana.persistence.enabled
      storageClass = var.cloud_provider == "gcp" && var.grafana.persistence.storageClass == "" ? "standard-rwo" : var.cloud_provider == "aws" && var.grafana.persistence.storageClass == "" ? "gp3" : var.grafana.persistence.storageClass
      size         = var.grafana.persistence.size
      type         = var.grafana.persistence.type
    }
    resources = {
      requests = var.grafana.resources.requests
      limits   = var.grafana.resources.limits
    }
    serviceAccount = {
      create      = var.grafana.serviceAccount.create
      name        = var.grafana.serviceAccount.name
      annotations = var.grafana.serviceAccount.annotations
    }
    ingress = {
      enabled     = var.grafana.ingress.enabled
      annotations = var.grafana.ingress.annotations
      hosts       = var.grafana.ingress.hosts
      path        = var.grafana.ingress.path
      pathType    = var.grafana.ingress.pathType
      tls         = var.grafana.ingress.tls
    }
    plugins     = var.grafana.plugins
    datasources = var.grafana.datasources
    alerting    = var.grafana.alerting
    dashboards  = var.grafana.dashboards
  }
}
