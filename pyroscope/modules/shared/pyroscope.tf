resource "helm_release" "pyroscope" {
  name             = var.helm_release_name
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "pyroscope"
  namespace        = var.namespace
  version          = var.pyroscope_helm_version
  create_namespace = true

  values = [yamlencode(local.pyroscope_config), yamlencode(var.pyroscope_extra)]
}
