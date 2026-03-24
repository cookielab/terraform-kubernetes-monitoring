locals {
  mimir_protocol = length(var.mimir.gateway.ingress.tls) > 0 ? "https" : "http"
  mimir_base_url = (
    var.mimir.gateway.ingress.enabled && length(var.mimir.gateway.ingress.hosts) > 0
    ? "${local.mimir_protocol}://${var.mimir.gateway.ingress.hosts[0]}"
    : "http://mimir-gateway.${var.namespace}.svc.cluster.local:80"
  )
}

output "mimir_gateway_url" {
  value = local.mimir_base_url
}

output "mimir_write_url" {
  value = "${local.mimir_base_url}/api/v1/push"
}
