locals {
  tempo_protocol           = length(var.tempo.gateway.ingress.tls) > 0 ? "https" : "http"
  tempo_base_url           = (
    var.tempo.gateway.ingress.enabled && length(var.tempo.gateway.ingress.hosts) > 0
    ? "${local.tempo_protocol}://${var.tempo.gateway.ingress.hosts[0]}"
    : "http://tempo-gateway.${var.namespace}.svc.cluster.local:80"
  )
  tempo_otlp_grpc_internal = "http://tempo-distributor.${var.namespace}.svc.cluster.local:4317"
  tempo_otlp_http_internal = "http://tempo-distributor.${var.namespace}.svc.cluster.local:4318"
}

output "tempo_gateway_url" {
  value = local.tempo_base_url
}

output "tempo_otlp_grpc_url" {
  value = (
    var.tempo.gateway.ingress.enabled && length(var.tempo.gateway.ingress.hosts) > 0
    ? local.tempo_base_url
    : local.tempo_otlp_grpc_internal
  )
}

output "tempo_otlp_http_url" {
  value = (
    var.tempo.gateway.ingress.enabled && length(var.tempo.gateway.ingress.hosts) > 0
    ? local.tempo_base_url
    : local.tempo_otlp_http_internal
  )
}
