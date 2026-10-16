# The chart has no gateway (unlike mimir/loki), so the module ships a small nginx
# that routes push/query paths to the right components and can enforce basic auth.
# Rendered through the chart's extraObjects, so no kubernetes provider is needed.
locals {
  gateway_name       = "${var.helm_release_name}-gateway"
  gateway_basic_auth = var.pyroscope.gateway.basicAuth.existingSecret != null
  gateway_upstream   = "${var.helm_release_name}-%s.${var.namespace}.svc.cluster.local:4040"

  gateway_labels = {
    "app.kubernetes.io/name"      = "pyroscope"
    "app.kubernetes.io/instance"  = var.helm_release_name
    "app.kubernetes.io/component" = "gateway"
  }

  gateway_routes = {
    "/ingest"                                = "distributor"
    "/push.v1.PusherService/"                = "distributor"
    "/settings.v1.SettingsService/"          = "tenant-settings"
    "/adhocprofiles.v1.AdHocProfileService/" = "ad-hoc-profiles"
    "/"                                      = "query-frontend"
  }

  gateway_nginx_conf = <<-EOT
    worker_processes auto;
    error_log /dev/stderr warn;
    pid /tmp/nginx.pid;

    events {
      worker_connections 1024;
    }

    http {
      client_body_temp_path /tmp/client_temp;
      proxy_temp_path       /tmp/proxy_temp;
      fastcgi_temp_path     /tmp/fastcgi_temp;
      uwsgi_temp_path       /tmp/uwsgi_temp;
      scgi_temp_path        /tmp/scgi_temp;

      access_log off;
      client_max_body_size 64m;
      proxy_http_version   1.1;
      proxy_read_timeout   300s;
      proxy_set_header     Host $host;

      server {
        listen 8080;

        %{~if local.gateway_basic_auth~}
        auth_basic           "Pyroscope";
        auth_basic_user_file /etc/nginx/secrets/.htpasswd;
        %{~endif~}

        location = /ready {
          auth_basic off;
          return 200 "ready\n";
        }
        %{~for path, component in local.gateway_routes~}

        location ${path} {
          proxy_pass http://${format(local.gateway_upstream, component)};
        }
        %{~endfor~}
      }
    }
  EOT

  gateway_objects = [
    {
      apiVersion = "v1"
      kind       = "ConfigMap"
      metadata   = { name = local.gateway_name, labels = local.gateway_labels }
      data       = { "nginx.conf" = local.gateway_nginx_conf }
    },
    {
      apiVersion = "apps/v1"
      kind       = "Deployment"
      metadata   = { name = local.gateway_name, labels = local.gateway_labels }
      spec = {
        replicas = var.pyroscope.gateway.replicas
        selector = { matchLabels = local.gateway_labels }
        template = {
          metadata = {
            labels      = local.gateway_labels
            annotations = { "checksum/config" = sha256(local.gateway_nginx_conf) }
          }
          spec = {
            nodeSelector = var.pyroscope.gateway.nodeSelector
            tolerations  = var.pyroscope.gateway.tolerations
            containers = [{
              name      = "nginx"
              image     = "${var.pyroscope.gateway.image.registry}/${var.pyroscope.gateway.image.repository}:${var.pyroscope.gateway.image.tag}"
              ports     = [{ name = "http", containerPort = 8080 }]
              resources = var.pyroscope.gateway.resources
              readinessProbe = {
                httpGet = { path = "/ready", port = "http" }
              }
              securityContext = {
                allowPrivilegeEscalation = false
                readOnlyRootFilesystem   = true
                runAsNonRoot             = true
                capabilities             = { drop = ["ALL"] }
              }
              volumeMounts = concat(
                [
                  { name = "config", mountPath = "/etc/nginx" },
                  { name = "tmp", mountPath = "/tmp" },
                ],
                local.gateway_basic_auth ? [{ name = "auth", mountPath = "/etc/nginx/secrets" }] : [],
              )
            }]
            volumes = concat(
              [
                { name = "config", configMap = { name = local.gateway_name } },
                { name = "tmp", emptyDir = {} },
              ],
              local.gateway_basic_auth ? [{ name = "auth", secret = { secretName = var.pyroscope.gateway.basicAuth.existingSecret } }] : [],
            )
          }
        }
      }
    },
    {
      apiVersion = "v1"
      kind       = "Service"
      metadata   = { name = local.gateway_name, labels = local.gateway_labels }
      spec = {
        selector = local.gateway_labels
        ports    = [{ name = "http", port = 80, targetPort = "http" }]
      }
    },
  ]

  gateway_ingress = {
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata = {
      name        = local.gateway_name
      labels      = local.gateway_labels
      annotations = var.pyroscope.gateway.ingress.annotations
    }
    spec = merge(
      length(var.pyroscope.gateway.ingress.tls) > 0 ? { tls = var.pyroscope.gateway.ingress.tls } : {},
      {
        rules = [for host in var.pyroscope.gateway.ingress.hosts : {
          host = host
          http = {
            paths = [{
              path     = var.pyroscope.gateway.ingress.path
              pathType = var.pyroscope.gateway.ingress.pathType
              backend  = { service = { name = local.gateway_name, port = { name = "http" } } }
            }]
          }
        }]
      },
    )
  }
}
