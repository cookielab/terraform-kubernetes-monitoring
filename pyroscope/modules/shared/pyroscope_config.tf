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
    # The chart ingress has no auth and needs per-component routing; the gateway owns ingress instead.
    ingress = {
      enabled = false
    }
    extraObjects = [
      for object in concat(local.gateway_objects, [local.gateway_ingress]) : object
      if var.pyroscope.gateway.enabled && (object.kind != "Ingress" || var.pyroscope.gateway.ingress.enabled)
    ]
  }
}
