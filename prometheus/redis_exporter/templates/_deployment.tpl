{{ define "elasticsearch_exporter_deployment" }}
{{- $port := default 5132 .port }}
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
        prometheus-exporter: redis
    spec:
      containers:
        - name: redis-exporter
          command:
          - /bin/redis_exporter
          - -redis.addr
          - "{{ .redis_addr }}"
          - -redis.alias
          - "{{ default "" .redis_alias }}"
          - -redis.password
          - "{{ default "" .redis_password }}"
          - -separator
          - "{{ default "," .separator }}"
          - -check-keys
          - "{{ default "" .check_keys }}"
          - -web.listen-address
          - ":{{ $port }}"
          - -web.telemetry-path
          - "{{ default "/metrics" .telemetry_path }}"
          - -namespace
          - "{{ default "redis" .namespace }}"
          - -redis-only-metrics
          - "{{ default "true" .redis_only_metrics }}"
          - -log-format
          - "{{ default "json" .log_formant }}"
          - -debug
          - "{{ default "false" .debug }}"
          image: oliver006/redis_exporter:v0.13
          resources:
            limits:
              cpu: "0.1"
              memory: "100Mi"
          ports:
          - name: redis-metrics
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
