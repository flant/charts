{{ define "rmq_exporter_deployment" }}
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
        prometheus-exporter: rmq
    spec:
      containers:
        - name: rmq-exporter
          image: kbudde/rabbitmq-exporter:v0.24.0
          resources:
            limits:
              cpu: "0.1"
              memory: "100Mi"
          env:
          - name: RABBIT_URL
            value: "{{ .rabbit_url }}"
          - name: RABBIT_USER
            value: "{{ default "guest" .rabbit_user }}"
          - name: RABBIT_PASSWORD
            value: "{{ default "guest" .rabbit_password }}"
{{- if .rabbit_user_file }}
          - name: RABBIT_USER_FILE
            value: "{{ .rabbit_user_file }}"
{{- end }}
{{- if .rabbit_password_file }}
          - name: RABBIT_PASSWORD_FILE
            value: "{{ .rabbit_password_file }}"
{{- end }}
          - name: PUBLISH_PORT
            value: "{{ default "5132" .publish_port }}"
          - name: OUTPUT_FORMAT
            value: "{{ default "JSON" .output_format }}"
          - name: LOG_LEVEL
            value: "{{ default "info" .log_level }}"
          - name: CAFILE
            value: "{{ default "ca.pem" .cafile }}"
          - name: SKIPVERIFY
            value: "{{ default "false" .skipverify }}"
          - name: INCLUDE_QUEUES
            value: "{{ default ".*" .include_queries }}"
          - name: SKIP_QUEUES
            value: "{{ default "^$" .skip_queries }}"
          - name: RABBIT_CAPABILITIES
            value: "{{ default "exchange,node,overview,queue" .rabbit_capabilities }}"
{{- if .rabbit_exporters }}
          - name: RABBIT_EXPORTERS
            value: {{ .rabbit_exporters }}
{{- end }}
          ports:
          - name: rmq-metrics
            containerPort: {{ default "5132" .publish_port }}
            protocol: TCP
          livenessProbe:
              httpGet:
                port: {{ default "5132" .publish_port }}
                path: /metrics
              initialDelaySeconds: 30
              periodSeconds: 60
              timeoutSeconds: 5
          readinessProbe:
              httpGet:
                port: {{ default "5132" .publish_port }}
                path: /metrics
{{- end }}
