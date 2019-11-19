# Terragrunt templates to support a reference architecture for gcloud
# Copyright (C) 2019 Samuel Gendler
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

output "name" {
  description = "Cluster name"
  value       = module.gke.name
}

output "type" {
  description = "Cluster type (regional / zonal)"
  value       = module.gke.type
}

output "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.gke.location
}

output "region" {
  description = "Cluster region"
  value       = module.gke.region
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = module.gke.zones
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.gke.endpoint
}

output "min_master_version" {
  description = "Minimum master kubernetes version"
  value       = module.gke.min_master_version
}

output "logging_service" {
  description = "Logging service used"
  value       = module.gke.logging_service
}

output "monitoring_service" {
  description = "Monitoring service used"
  value       = module.gke.monitoring_service
}

output "master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = module.gke.master_authorized_networks_config
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = module.gke.master_version
}

output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.gke.ca_certificate
}

output "network_policy_enabled" {
  description = "Whether network policy enabled"
  value       = module.gke.network_policy_enabled
}

output "http_load_balancing_enabled" {
  description = "Whether http load balancing enabled"
  value       = module.gke.http_load_balancing_enabled
}

output "horizontal_pod_autoscaling_enabled" {
  description = "Whether horizontal pod autoscaling enabled"
  value       = module.gke.horizontal_pod_autoscaling_enabled
}

output "kubernetes_dashboard_enabled" {
  description = "Whether kubernetes dashboard enabled"
  value       = module.gke.kubernetes_dashboard_enabled
}

output "node_pools_names" {
  description = "List of node pools names"
  value       = module.gke.node_pools_names
}

output "node_pools_versions" {
  description = "List of node pools versions"
  value       = module.gke.node_pools_versions
}

output "service_account" {
  description = "The service account to default running nodes as if not overridden in `node_pools`."
  value       = module.gke.service_account
}

output "gke" {
  description = "The outputs exported by the gke module"
  value       = module.gke
}

output "client_token" {
  sensitive = true
  value     = base64encode(data.google_client_config.default.access_token)
}

output "get_credentials" {
  description = "Gcloud get-credentials command"
  value       = format("gcloud container clusters get-credentials --project %s --zone %s --internal-ip %s", local.project_id, module.gke.location, module.gke.name)
}

output "bastion_ssh" {
  description = "Gcloud compute ssh to the bastion host command"
  value       = format("gcloud beta compute ssh %s --tunnel-through-iap --project %s --zone %s -- -A -L8888:localhost:8888", data.terraform_remote_state.bastion.outputs.hostname, local.project_id, regex(".*/zones/(.*)/instances/*", data.terraform_remote_state.bastion.outputs.self_link)[0])
}

output "bastion_kubectl" {
  description = "kubectl command using the local proxy once the bastion_ssh command is running"
  value       = "HTTPS_PROXY=localhost:8888 kubectl get pods --all-namespaces"
}
