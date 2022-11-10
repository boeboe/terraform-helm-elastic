variable "elastic_helm_repo" {
  description = "elastic helm repository"
  type        = string
  default     = "https://helm.elastic.co"
}

variable "elastic_helm_version" {
  description = "elastic helm chart version"
  type        = string
}

variable "elastic_helm_namespace" {
  description = "elastic helm namespace"
  type        = string
  default     = "elastic"
}


variable "elasticsearch_settings" {
  description = "elasticsearch settings"
  type        = map(any)
  default     = {}
}

variable "elasticsearch_enabled" {
  description = "enable helm install of elasticsearch"
  type        = bool
  default     = true
}

variable "kibana_settings" {
  description = "kibana settings"
  type        = map(any)
  default     = {}
}

variable "kibana_enabled" {
  description = "enable helm install of kibana"
  type        = bool
  default     = false
}

variable "apm_server_settings" {
  description = "apm-server settings"
  type        = map(any)
  default     = {}
}

variable "apm_server_enabled" {
  description = "enable helm install of apm-server"
  type        = bool
  default     = false
}

variable "filebeat_settings" {
  description = "filebeat settings"
  type        = map(any)
  default     = {}
}

variable "filebeat_enabled" {
  description = "enable helm install of filebeat"
  type        = bool
  default     = false
}

variable "metricbeat_settings" {
  description = "metricbeat settings"
  type        = map(any)
  default     = {}
}

variable "metricbeat_enabled" {
  description = "enable helm install of metricbeat"
  type        = bool
  default     = false
}

variable "logstash_settings" {
  description = "logstash settings"
  type        = map(any)
  default     = {}
}

variable "logstash_enabled" {
  description = "enable helm install of logstash"
  type        = bool
  default     = false
}
