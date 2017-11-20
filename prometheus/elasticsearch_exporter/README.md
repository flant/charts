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
