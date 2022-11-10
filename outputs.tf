output "elasticsearch_helm_metadata" {
  description = "block status of the elasticsearch helm release"
  value       = length(helm_release.elasticsearch) > 0 ? helm_release.elasticsearch[0].metadata : null
}

output "kibana_helm_metadata" {
  description = "block status of the kibana helm release"
  value       = length(helm_release.kibana) > 0 ? helm_release.kibana[0].metadata : null
}

output "apm_server_helm_metadata" {
  description = "block status of the apm-server helm release"
  value       = length(helm_release.apm_server) > 0 ? helm_release.apm_server[0].metadata : null
}

output "filebeat_helm_metadata" {
  description = "block status of the filebeat helm release"
  value       = length(helm_release.filebeat) > 0 ? helm_release.filebeat[0].metadata : null
}

output "metricbeat_helm_metadata" {
  description = "block status of the metricbeat helm release"
  value       = length(helm_release.metricbeat) > 0 ? helm_release.metricbeat[0].metadata : null
}

output "logstash_helm_metadata" {
  description = "block status of the logstash helm release"
  value       = length(helm_release.logstash) > 0 ? helm_release.logstash[0].metadata : null
}

