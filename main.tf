locals {
  elastic_helm_repo      = var.elastic_helm_repo
  elastic_helm_version   = var.elastic_helm_version
  elastic_helm_namespace = var.elastic_helm_namespace

  elasticsearch_settings = var.elasticsearch_settings
  elasticsearch_enabled  = var.elasticsearch_enabled

  kibana_settings = var.kibana_settings
  kibana_enabled  = var.kibana_enabled

  apm_server_settings = var.apm_server_settings
  apm_server_enabled  = var.apm_server_enabled

  filebeat_settings = var.filebeat_settings
  filebeat_enabled  = var.filebeat_enabled

  metricbeat_settings = var.metricbeat_settings
  metricbeat_enabled  = var.metricbeat_enabled

  logstash_settings = var.logstash_settings
  logstash_enabled  = var.logstash_enabled
}

resource "helm_release" "elasticsearch" {
  count = local.elasticsearch_enabled ? 1 : 0

  name             = "elasticsearch"
  repository       = local.elastic_helm_repo
  chart            = "elasticsearch"
  version          = local.elastic_helm_version
  create_namespace = true
  namespace        = local.elastic_helm_namespace

  dynamic "set" {
    for_each = local.elasticsearch_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "helm_release" "kibana" {
  count = local.kibana_enabled ? 1 : 0

  name             = "kibana"
  repository       = local.elastic_helm_repo
  chart            = "kibana"
  version          = local.elastic_helm_version
  create_namespace = true
  namespace        = local.elastic_helm_namespace

  dynamic "set" {
    for_each = local.kibana_settings
    content {
      name  = set.key
      value = set.value
    }
  }

  depends_on = [
    helm_release.elasticsearch
  ]
}

resource "helm_release" "apm_server" {
  count = local.apm_server_enabled ? 1 : 0

  name             = "apm_server"
  repository       = local.elastic_helm_repo
  chart            = "apm_server"
  version          = local.elastic_helm_version
  create_namespace = true
  namespace        = local.elastic_helm_namespace

  dynamic "set" {
    for_each = local.apm_server_settings
    content {
      name  = set.key
      value = set.value
    }
  }

  depends_on = [
    helm_release.elasticsearch
  ]
}

resource "helm_release" "filebeat" {
  count = local.filebeat_enabled ? 1 : 0

  name             = "filebeat"
  repository       = local.elastic_helm_repo
  chart            = "filebeat"
  version          = local.elastic_helm_version
  create_namespace = true
  namespace        = local.elastic_helm_namespace

  dynamic "set" {
    for_each = local.filebeat_settings
    content {
      name  = set.key
      value = set.value
    }
  }

  depends_on = [
    helm_release.elasticsearch
  ]
}

resource "helm_release" "metricbeat" {
  count = local.metricbeat_enabled ? 1 : 0

  name             = "metricbeat"
  repository       = local.elastic_helm_repo
  chart            = "metricbeat"
  version          = local.elastic_helm_version
  create_namespace = true
  namespace        = local.elastic_helm_namespace

  dynamic "set" {
    for_each = local.metricbeat_settings
    content {
      name  = set.key
      value = set.value
    }
  }

  depends_on = [
    helm_release.elasticsearch
  ]
}

resource "helm_release" "logstash" {
  count = local.logstash_enabled ? 1 : 0

  name             = "logstash"
  repository       = local.elastic_helm_repo
  chart            = "logstash"
  version          = local.elastic_helm_version
  create_namespace = true
  namespace        = local.elastic_helm_namespace

  dynamic "set" {
    for_each = local.logstash_settings
    content {
      name  = set.key
      value = set.value
    }
  }

  depends_on = [
    helm_release.elasticsearch
  ]
}
