# Usage

## Helm

### Deployment example

```yaml
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: {{ .Chart.Name }}
spec:
  template:
    metadata:
      labels:
        service: {{ .Chart.Name }}
        prometheus-exporter: php-fpm
    spec:
      containers:
{{- include "php-fpm-exporter-container" .Values.php_fpm_exporter.containers.first | indent 6 }}
```

### values.yaml

```yaml
php_fpm_exporter: # subchart name
  containers:
    first: # you can specify multiple container contexts
      port: 5132 # port for php-fpm-exporter container
      endpoint: "http://127.0.0.1:80/status" # php-fpm status page URL
  service_name: hlebalo-php-fpm-metrics # name of created Service
  pod_labels: # map of pod labels to populate Service selector
    prometheus-exporter: php-fpm
```

## Application config

### nginx

```nginx
location = /status {
    allow 127.0.0.0/8;
    deny all;
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $fastcgi_script_name;
    access_log off;
}
```

### php-fpm

```
pm.status_path = /status
```

## Prometheus Operator

### ServiceMonitor

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    k8s-app: php-fpm-exporter
  name: php-fpm-exporter
  namespace: monitoring
spec:
  endpoints:
  - interval: 30s
    port: php-fpm-metrics
  jobLabel: php-fpm
  namespaceSelector:
    any: true
  selector:
    matchLabels:
      servicemonitor/php-fpm-exporter: "(.*)"
```
