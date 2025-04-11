resource "helm_release" "mimir" {
  name             = "mimir"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "mimir-distributed"
  namespace        = var.namespace
  version          = var.mimir_helm_version
  create_namespace = true

  values = [yamlencode(local.mimir_config)]
}


