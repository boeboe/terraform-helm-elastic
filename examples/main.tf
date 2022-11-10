locals {
  kubeconfig_path = "~/.kube/config"

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

provider "kubernetes" {
  config_path = local.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = local.kubeconfig_path
  }
}

module "elastic" {
  source = "./.."

  elastic_helm_version = local.elastic_helm_version

  elasticsearch_settings = local.elasticsearch_settings

  kibana_enabled  = local.kibana_enabled
  kibana_settings = local.kibana_settings

  filebeat_enabled  = local.filebeat_enabled
  filebeat_settings = local.filebeat_settings
}

output "elasticsearch_helm_metadata" {
  description = "block status of the elasticsearch helm release"
  value       = module.elastic.elasticsearch_helm_metadata[0]
}

data "kubernetes_service" "kibana" {
  metadata {
    name = "kibana"
    namespace = "elastic"
  }

  depends_on = [
    module.elastic
  ]
}

output "kibana_loadbalancer_ip" {
  description = "external loadbalancer ip address of kibana"
  value = data.kubernetes_service.kibana.status[0].load_balancer[0].ingress[0].ip
}
