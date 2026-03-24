locals {
  grafana_protocol = length(var.grafana.ingress.tls) > 0 ? "https" : "http"
  grafana_base_url = (
    var.grafana.ingress.enabled && length(var.grafana.ingress.hosts) > 0
    ? "${local.grafana_protocol}://${var.grafana.ingress.hosts[0]}"
    : "http://grafana.${var.namespace}.svc.cluster.local:80"
  )
}

output "grafana_url" {
  value = local.grafana_base_url
}
