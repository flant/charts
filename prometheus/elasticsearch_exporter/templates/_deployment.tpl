{{ define "elasticsearch_exporter_deployment" }}
{{- $port := default 5132 .port }}
{{- $export_all := default true .export_all }}
{{- $export_indices := default true .export_indices }}
{{- $timeout := default "5s" .timeout }}
---
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: {{ .name }}
spec:
  replicas: 1
  template:
    metadata:
      labels:
        prometheus-exporter: elasticsearch
    spec:
      containers:
        - name: elasticsearch-exporter
          command:
          - /bin/elasticsearch_exporter
          - -web.listen-address
          - :{{ $port }}
          - -web.telemetry-path
          - /metrics
{{- if $export_all }}
          - -es.all
{{- end }}
{{- if $export_indices }}
          - -es.indices
{{- end }}
          - -es.timeout
          - {{ $timeout }}
          - -es.uri
          - {{ .es_uri }}
          image: justwatch/elasticsearch_exporter:1.0.2rc2
          resources:
            limits:
              cpu: "0.1"
              memory: "100Mi"
          ports:
          - name: es-metrics
            containerPort: {{ $port }}
            protocol: TCP
          livenessProbe:
              httpGet:
                port: {{ $port }}
                path: /metrics
              initialDelaySeconds: 30
              periodSeconds: 60
              timeoutSeconds: 5
          readinessProbe:
              httpGet:
                port: {{ $port }}
                path: /metrics
{{- end }}
