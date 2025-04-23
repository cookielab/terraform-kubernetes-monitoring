output "loki_gateway_url" {
  value = "http://loki-gateway.${var.namespace}.svc.cluster.local:80"
}

output "loki_write_url" {
  value = "http://loki-gateway.${var.namespace}.svc.cluster.local:80/api/v1/push"
}
