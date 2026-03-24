locals {
  loki_protocol = length(var.loki.gateway.ingress.tls) > 0 ? "https" : "http"
  loki_base_url = (
    var.loki.gateway.ingress.enabled && length(var.loki.gateway.ingress.hosts) > 0
    ? "${local.loki_protocol}://${var.loki.gateway.ingress.hosts[0]}"
    : "http://loki-gateway.${var.namespace}.svc.cluster.local:80"
  )
}

output "loki_gateway_url" {
  value = local.loki_base_url
}

output "loki_write_url" {
  value = "${local.loki_base_url}/api/v1/push"
}
