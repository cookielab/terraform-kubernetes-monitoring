locals {
  pyroscope_protocol = length(var.pyroscope.gateway.ingress.tls) > 0 ? "https" : "http"
}

output "pyroscope_url" {
  value = (
    var.pyroscope.gateway.enabled && var.pyroscope.gateway.ingress.enabled && length(var.pyroscope.gateway.ingress.hosts) > 0
    ? "${local.pyroscope_protocol}://${var.pyroscope.gateway.ingress.hosts[0]}"
    : var.pyroscope.gateway.enabled
    ? "http://${var.helm_release_name}-gateway.${var.namespace}.svc.cluster.local:80"
    : "http://${var.helm_release_name}-query-frontend.${var.namespace}.svc.cluster.local:4040"
  )
}

output "pyroscope_write_url" {
  value = "http://${var.helm_release_name}-distributor.${var.namespace}.svc.cluster.local:4040"
}
