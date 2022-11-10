# terraform-helm-elastic

![Terraform Version](https://img.shields.io/badge/terraform-≥_1.0.0-blueviolet)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/boeboe/terraform-helm-elastic?label=registry)](https://registry.terraform.io/modules/boeboe/elastic/helm)
[![GitHub issues](https://img.shields.io/github/issues/boeboe/terraform-helm-elastic)](https://github.com/boeboe/terraform-helm-elastic/issues)
[![Open Source Helpers](https://www.codetriage.com/boeboe/terraform-helm-elastic/badges/users.svg)](https://www.codetriage.com/boeboe/terraform-helm-elastic)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

This terraform module will deploy [elastic services](https://www.elastic.co) on any kubernetes cluster, using the official [helm chart](https://github.com/elastic/helm-charts).

| Helm Chart | Repo | Default Values |
|------------|------|--------|
| elasticsearch | [repo](https://artifacthub.io/packages/helm/elastic/elasticsearch) | [values](https://artifacthub.io/packages/helm/elastic/elasticsearch?modal=values) |
| kibana | [repo](https://artifacthub.io/packages/helm/elastic/kibana) | [values](https://artifacthub.io/packages/helm/elastic/kibana?modal=values) |
| apm-server | [repo](https://artifacthub.io/packages/helm/elastic/apm-server) | [values](https://artifacthub.io/packages/helm/elastic/apm-server?modal=values) |
| filebeat | [repo](https://artifacthub.io/packages/helm/elastic/filebeat) | [values](https://artifacthub.io/packages/helm/elastic/filebeat?modal=values) |
| metricbeat | [repo](https://artifacthub.io/packages/helm/elastic/metricbeat) | [values](https://artifacthub.io/packages/helm/elastic/metricbeat?modal=values) |
| logstash | [repo](https://artifacthub.io/packages/helm/elastic/logstash) | [values](https://artifacthub.io/packages/helm/elastic/logstash?modal=values) |


## Usage

``` hcl
provider "kubernetes" {
  config_path    = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
  }
}

module "elastic" {
  source  = "boeboe/elastic/helm"
  version = "0.0.1"

  elastic_helm_version = "7.17.3"

  elasticsearch_settings = {
    "fullnameOverride"   = "elasticsearch"
  }

  kibana_enabled = true
  kibana_settings = {
    "fullnameOverride"   = "kibana"
    "service.type"       = "LoadBalancer"
    "extraEnvs[0].name"  = "ELASTICSEARCH_HOSTS"
    "extraEnvs[0].value" = "http://elasticsearch:9200"
  }

  filebeat_enabled = true
  filebeat_settings = {
    "filebeatConfig.filebeat\\.yml" = <<FILEBEAT_CONFIG
      output.elasticsearch:
        hosts: ["http://elasticsearch:9200"]
        username: "elastic"
        password: "elastic123"
      filebeat.inputs:
        - type: container
          paths: 
            - '/var/log/containers/*.log'
      filebeat.autodiscover:
        providers:
          - type: kubernetes
            node: $\{NODE_NAME\}
            hints.enabled: true
            hints.default_config:
              type: container
              paths:
                - /var/log/containers/*.log
      setup.kibana:
          host: "kibana:5601"
    FILEBEAT_CONFIG
  }
}

output "prometheus_helm_metadata" {
  description = "block status of the prometheus prometheus helm release"
  value = module.prometheus.prometheus_helm_metadata[0]
}
```

Check the [examples](examples) for more details.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| prometheus_helm_version | prometheus helm chart version | string | - | true |
| prometheus_helm_namespace | prometheus helm namespace | string | "prometheus" | false |
| prometheus_helm_repo | prometheus helm repository | string | "https://prometheus-community.github.io/helm-charts" | false |
| prometheus_settings | prometheus settings | map | {} | false |

> **INFO:** in order to overwrite specific versions of the `server`, `alertmanager`, `nodeExporter` or `pushgateway` containers used, override the correct `tag` parameters in the helm chart [default values](https://artifacthub.io/packages/helm/prometheus-community/prometheus?modal=values)

## Outputs

| Name | Description | Type |
|------|-------------|------|
| prometheus_helm_metadata | block status of the prometheus helm release | list |


Example output:

``` hcl
elasticsearch_helm_metadata = {
  "app_version" = "7.17.3"
  "chart" = "elasticsearch"
  "name" = "elasticsearch"
  "namespace" = "elastic"
  "revision" = 1
  "values" = "{\"extraEnvs\":[{\"name\":\"ELASTIC_PASSWORD\",\"value\":\"elastic123\"}]}"
  "version" = "7.17.3"
}
```

## More information

TBC

## License

terraform-helm-elastic is released under the **MIT License**. See the bundled [LICENSE](LICENSE) file for details.
