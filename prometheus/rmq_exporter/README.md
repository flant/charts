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
{{- include "php-fpm-exporter-container" .Values.php_fpm_exporter.containers.first }}
```

### values.yaml

```yaml
php-fpm-exporter: # subchart name
  containers:
    first: # you can specify multiple container contexts
      port: 5132 # port for php-fpm-exporter container
      endpoint: "http://127.0.0.1:80/status" # php-fpm status page URL
  service_name: hlebalo-php-fpm-metrics # name of created Service
  pod_labels: # map of pod labels to populate service selector
    prometheus-exporter: php-fpm
```

## Application config

### nginx

```
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
