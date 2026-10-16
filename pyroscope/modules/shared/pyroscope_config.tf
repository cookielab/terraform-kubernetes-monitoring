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
        # Chart ingress routes to per-component services only when
        # len(pyroscope.components) > 1; with one key it targets a non-existent "pyroscope" service.
        query-frontend = {}
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
      # With the gateway, the module renders its own ingress pointing at it.
      enabled     = var.pyroscope.ingress.enabled && !var.pyroscope.gateway.enabled
      className   = var.pyroscope.ingress.className
      annotations = var.pyroscope.ingress.annotations
      hosts       = var.pyroscope.ingress.hosts
      pathType    = var.pyroscope.ingress.pathType
      tls         = var.pyroscope.ingress.tls
    }
    extraObjects = [
      for object in concat(local.gateway_objects, [local.gateway_ingress]) : object
      if var.pyroscope.gateway.enabled && (object.kind != "Ingress" || var.pyroscope.ingress.enabled)
    ]
  }
}
