resource "helm_release" "grafana" {
  name       = var.helm_release_name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = var.namespace
  version    = var.grafana_helm_version

  values = [yamlencode(local.grafana_config)]
}
