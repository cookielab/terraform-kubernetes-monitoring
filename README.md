# Cookielab monitoring modules

This directory contains Terraform modules for deploying observability tools on Kubernetes using Helm charts and backed by storage on different cloud providers.

## Structure

- `grafana/` - Grafana
    - Storage for dashboards
    - UI for viewing metrics, logs, traces
- `mimir/` - Grafana Mimir
    - Storage for prometheus metrics
- `loki/` - Loki
    - Storage for logs
- `tempo/` - Tempo
    - Storage for traces
- `fluent-bit/` - Fluent Bit
    - Sending logs to Loki or other destinations

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

## TODO
- Add proper outputs
- Add ingress resources for all services
