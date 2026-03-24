# Cookielab monitoring modules

This directory contains Terraform modules for deploying observability tools on Kubernetes using Helm charts and backed by storage on different cloud providers.

## Structure

- `grafana/` - Grafana
    - Storage for dashboards
    - UI for viewing metrics, logs, traces
    - Ingress support with TLS
    - Outputs: `grafana_url`
- `mimir/` - Grafana Mimir
    - Storage for prometheus metrics
    - Gateway with ingress support
    - Outputs: `mimir_gateway_url`, `mimir_write_url`
- `loki/` - Loki
    - Storage for logs
    - Gateway with ingress support
    - Outputs: `loki_gateway_url`, `loki_write_url`
- `tempo/` - Tempo
    - Storage for traces
    - Gateway with ingress support
    - Outputs: `tempo_gateway_url`, `tempo_otlp_grpc_url`, `tempo_otlp_http_url`

Each module's `aws/` submodule supports both IRSA and EKS Pod Identity for IAM authentication.

## Scraping and OTel collector

### Metrics
- For scraping metrics, we recommend use our Grafana alloy modules
    - Nodes metrics: https://github.com/cookielab/terraform-kubernetes-grafana-alloy/tree/main/modules/node
    - Pods metrics: https://github.com/cookielab/terraform-kubernetes-grafana-alloy/tree/main/modules/cluster

### Logs
- For scraping logs, we recommend recommend use our Grafana alloy modules
    - Pod logs: https://github.com/cookielab/terraform-kubernetes-grafana-alloy/tree/main/modules/loki-logs

### Traces
- For OTel collector, we recommend use our Grafana alloy modules
    - OTel collector: https://github.com/cookielab/terraform-kubernetes-grafana-alloy/tree/main/modules/otel-collector

