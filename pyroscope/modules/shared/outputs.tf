locals {
  pyroscope_protocol = length(var.pyroscope.ingress.tls) > 0 ? "https" : "http"
}

output "pyroscope_url" {
  value = (
    var.pyroscope.ingress.enabled && length(var.pyroscope.ingress.hosts) > 0
    ? "${local.pyroscope_protocol}://${var.pyroscope.ingress.hosts[0]}"
    : "http://${var.helm_release_name}-query-frontend.${var.namespace}.svc.cluster.local:4040"
  )
}

output "pyroscope_write_url" {
  value = "http://${var.helm_release_name}-distributor.${var.namespace}.svc.cluster.local:4040"
}
