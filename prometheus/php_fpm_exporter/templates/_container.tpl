{{ define "php_fpm_exporter_container" }}
- name: php-fpm-exporter
  command:
  - /php-fpm-exporter
  - --addr
  - 0.0.0.0:{{ .port }}
  - --endpoint
  - {{ .endpoint }}
  image: flant/php-fpm-exporter:v0.3.3
  resources:
    limits:
      cpu: "0.1"
      memory: "50Mi"
  imagePullPolicy: Always
  ports:
  - name: php-fpm-metrics
    containerPort: {{ .port }}
    protocol: TCP
  livenessProbe:
    httpGet:
      port: {{ .port }}
      path: /metrics
    initialDelaySeconds: 30
    periodSeconds: 60
    timeoutSeconds: 5
  readinessProbe:
    httpGet:
      port: {{ .port }}
      path: /metrics
{{- end }}
