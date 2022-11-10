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

output "elasticsearch_helm_metadata" {
  description = "block status of the elasticsearch helm release"
  value       = module.elastic.elasticsearch_helm_metadata[0]
}
```

Check the [examples](examples) for more details.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| elastic_helm_version | elastic helm chart version | string | - | true |
| elastic_helm_namespace | elastic helm namespace | string | "prometheus" | false |
| elastic_helm_repo | elastic helm repository | string | "https://helm.elastic.co" | false |
| elasticsearch_settings | elasticsearch settings | map | {} | false |
| elasticsearch_enabled | enable helm install of elasticsearch | bool | true | false |
| kibana_settings | kibana settings | map | {} | false |
| kibana_enabled | enable helm install of kibana | bool | false | false |
| apm_server_settings | apm-server settings | map | {} | false |
| apm_server_enabled | enable helm install of apm-server | bool | false | false |
| filebeat_settings | filebeat settings | map | {} | false |
| filebeat_enabled | enable helm install of filebeat | bool | false | false |
| metricbeat_settings | metricbeat settings | map | {} | false |
| metricbeat_enabled | enable helm install of metricbeat | bool | false | false |
| logstash_settings | logstash settings | map | {} | false |
| logstash_enabled | enable helm install of logstash | bool | false | false |



## Outputs

| Name | Description | Type |
|------|-------------|------|
| elasticsearch_helm_metadata | block status of the elasticsearch helm release | list |
| kibana_helm_metadata | block status of the kibana helm release | list |
| apm_server_helm_metadata | block status of the apm-server helm release | list |
| filebeat_helm_metadata | block status of the filebeat helm release | list |
| metricbeat_helm_metadata | block status of the metricbeat helm release | list |
| logstash_helm_metadata | block status of the logstash helm release | list |


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
