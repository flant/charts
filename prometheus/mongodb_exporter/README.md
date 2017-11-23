# Usage

## Helm

### Deployment example

```yaml
{{- include "mongodb-exporter-deployment" .Values.rmq_exporter.deployments.first }}
```

### values.yaml

```yaml
mongodb_exporter:
  deployments:
    first:
      name: mongodb-exporter
      mongodb_uri: "mongodb://hleb:hlebinsky@172.23.23.13:27018/pekarnya"
      mongodb_collect_connpoolstats: "true"
      mongodb_collect_oplog: "true
  service_name: mongodb-exporter
```

## Prometheus Operator

### ServiceMonitor

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    k8s-app: mongodb-exporter
  name: mongodb-exporter
  namespace: monitoring
spec:
  endpoints:
  - interval: 30s
    port: mongodb-metrics
  jobLabel: mongodb
  namespaceSelector:
    any: true
  selector:
    matchLabels:
      servicemonitor/mongodb-exporter: "(.*)"
```
