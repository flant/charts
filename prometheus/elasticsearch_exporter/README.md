# Usage

## Helm

### Deployment example

```yaml
{{- include "elasticsearch-exporter-deployment" .Values.elasticsearch_exporter.deployments.first }}
```

### values.yaml

```yaml
elasticsearch_exporter:
  deployments:
    first:
      name: es-exporter # name of created Deployment
      es_uri: "http://elasticsearch:9200" # ElasticSearch URL
  service_name: es-metrics # name of created Service
```

## Prometheus Operator

### ServiceMonitor

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    k8s-app: elasticsearch-exporter
  name: elasticsearch-exporter
  namespace: monitoring
spec:
  endpoints:
  - interval: 30s
    port: es-metrics
  jobLabel: elasticsearch
  namespaceSelector:
    any: true
  selector:
    matchLabels:
      servicemonitor/elasticsearch-exporter: "(.*)"
```
