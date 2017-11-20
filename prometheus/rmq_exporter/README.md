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
