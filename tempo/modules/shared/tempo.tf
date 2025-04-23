resource "helm_release" "tempo" {
  name             = var.helm_release_name
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "tempo-distributed"
  namespace        = var.namespace
  version          = var.tempo_helm_version
  create_namespace = true

  values = [yamlencode(local.tempo_config)]
}
