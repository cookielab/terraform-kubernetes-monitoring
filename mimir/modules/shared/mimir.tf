resource "helm_release" "mimir" {
  name             = var.helm_release_name
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "mimir-distributed"
  namespace        = var.namespace
  version          = var.mimir_helm_version
  create_namespace = true

  values = [yamlencode(local.mimir_config), yamlencode(var.mimir_extra)]
}


