resource "helm_release" "loki" {
  name       = var.helm_release_name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = var.loki_helm_version
  namespace  = var.namespace

  values = [yamlencode(local.loki_config)]
}
