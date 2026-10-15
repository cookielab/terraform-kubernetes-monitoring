locals {
  pyroscope_config = {
    architecture = {
      microservices = {
        enabled = true
      }
    }
    pyroscope = {
      serviceAccount = var.pyroscope.serviceAccount
      nodeSelector   = var.pyroscope.nodeSelector
      tolerations    = var.pyroscope.tolerations
      components = {
        # Metastore keeps the v2 block index in raft; without a PVC a full restart loses it.
        metastore = {
          persistence = var.pyroscope.metastore.persistence
        }
      }
      structuredConfig = {
        multitenancy_enabled = var.pyroscope.multitenancyEnabled
        storage              = var.storage
      }
    }
    # Profiles are collected by an external Alloy (cookielab/terraform-kubernetes-grafana-alloy)
    alloy = {
      enabled = false
    }
    ingress = {
      enabled     = var.pyroscope.ingress.enabled
      className   = var.pyroscope.ingress.className
      annotations = var.pyroscope.ingress.annotations
      hosts       = var.pyroscope.ingress.hosts
      pathType    = var.pyroscope.ingress.pathType
      tls         = var.pyroscope.ingress.tls
    }
  }
}
