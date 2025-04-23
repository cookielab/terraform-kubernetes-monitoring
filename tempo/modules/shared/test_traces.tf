resource "kubernetes_manifest" "test_traces_cronjob" {
  count = var.tempo.test_traces.enabled ? 1 : 0
  manifest = {
    "apiVersion" = "batch/v1"
    "kind"       = "CronJob"
    "metadata" = {
      "name"      = var.tempo.test_traces.name
      "namespace" = var.namespace
    }
    "spec" = {
      "concurrencyPolicy"          = "Forbid"
      "successfulJobsHistoryLimit" = 1
      "failedJobsHistoryLimit"     = 2
      "schedule"                   = "0 * * * *"
      "jobTemplate" = {
        "spec" = {
          "backoffLimit"            = 0
          "ttlSecondsAfterFinished" = 3600
          "template" = {
            "spec" = {
              "containers" = [
                {
                  "name"  = "traces"
                  "image" = "ghcr.io/open-telemetry/opentelemetry-collector-contrib/telemetrygen:${var.tempo.test_traces.telemetrygen_image_version}"
                  "args" = [
                    "traces",
                    "--otlp-insecure",
                    "--rate",
                    "20",
                    "--duration",
                    "5s",
                    "--otlp-endpoint",
                    "${var.otel_collector.name}.${var.otel_collector.namespace}.svc.cluster.local:${var.otel_collector.port}"
                  ]
                }
              ]
              "restartPolicy" = "Never"
            }
          }
        }
      }
    }
  }
}
