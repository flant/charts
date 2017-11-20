# Using Flant's Chart collection

1. Add Flant's Chart collection to Helm's list of repos: `helm repo add flant-charts https://flant.github.io/charts`;
1. Add a `requirements.yaml` file to your Chart;
1. Do not forget to use the `helm dependency update` command in your Chart's directory. You must also add it to your CI/CD pipeline;

## requirements.yaml example

```yaml
dependencies:
- name: rmq_exporter
  version: 0.0.2
  repository: https://flant.github.io/charts
```
