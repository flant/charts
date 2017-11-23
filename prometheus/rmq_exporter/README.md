# Usage

## Helm

### Deployment example

```yaml
{{- include "rmq-exporter-deployment" .Values.rmq_exporter.deployments.first }}
```

### values.yaml

```yaml
rmq_exporter:
  deployments:
    first:
      name: rmq-exporter # name of created Deployment
      rabbit_url: "http://rabbitmq:15672" # RabbitMQ URL
  service_name: rmq-metrics # name of created Service
```

## Prometheus Operator

### ServiceMonitor

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    k8s-app: rmq-exporter
  name: rmq-exporter
  namespace: monitoring
spec:
  endpoints:
  - interval: 30s
    port: rmq-metrics
  jobLabel: rmq
  namespaceSelector:
    any: true
  selector:
    matchLabels:
      servicemonitor/rmq-exporter: "(.*)"
```
