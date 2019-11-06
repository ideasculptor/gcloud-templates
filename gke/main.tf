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

locals {
  project_id         = data.terraform_remote_state.service_project.outputs.project_id
  network_project_id = data.terraform_remote_state.vpc.outputs.project_id
  network            = data.terraform_remote_state.vpc.outputs.network_name
  subnetwork         = "${var.environment}-${var.region}-${var.subnet_short_name}"
  ip_range_pods      = "${local.subnetwork}-${var.pods_range_short_name}"
  ip_range_services  = "${local.subnetwork}-${var.services_range_short_name}"

  subnets = zipmap(data.terraform_remote_state.subnets.outputs.subnets_names,
  data.terraform_remote_state.subnets.outputs.subnets_ips)
  subnet_cidr_blocks = concat(var.authorized_cidr_blocks, [
    for name in data.terraform_remote_state.subnets.outputs.subnets_names : {
      cidr_block   = local.subnets[name]
      display_name = local.subnetwork
    } if name == local.subnetwork
  ])
  master_authorized_networks_config = [{
    cidr_blocks = local.subnet_cidr_blocks
  }]
}

module "gke" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"

  project_id                        = local.project_id
  network_project_id                = local.network_project_id
  registry_project_id               = local.project_id
  name                              = "gke-${var.environment}"
  description                       = var.description
  region                            = var.region
  regional                          = var.regional
  zones                             = var.zones
  network                           = local.network
  subnetwork                        = local.subnetwork
  ip_range_pods                     = local.ip_range_pods
  ip_range_services                 = local.ip_range_services
  create_service_account            = var.use_project_service_account ? false : var.create_service_account
  service_account                   = var.use_project_service_account ? data.terraform_remote_state.service_project.outputs.service_account_email : var.service_account
  master_authorized_networks_config = local.master_authorized_networks_config
  http_load_balancing               = var.http_load_balancing
  horizontal_pod_autoscaling        = var.horizontal_pod_autoscaling
  kubernetes_dashboard              = var.kubernetes_dashboard

  network_policy           = var.network_policy
  network_policy_provider  = var.network_policy_provider
  cluster_resource_labels  = var.cluster_resource_labels
  grant_registry_access    = var.grant_registry_access
  issue_client_certificate = var.issue_client_certificate
  kubernetes_version       = var.kubernetes_version
  logging_service          = var.logging_service
  maintenance_start_time   = var.maintenance_start_time
  monitoring_service       = var.monitoring_service
  node_pools               = var.node_pools
  node_pools_labels        = var.node_pools_labels
  node_pools_metadata      = var.node_pools_metadata
  node_pools_oauth_scopes  = var.node_pools_oauth_scopes
  node_pools_tags          = var.node_pools_tags
  node_version             = var.node_version

  authenticator_security_group = var.authenticator_security_group
  cloudrun                     = var.cloudrun
  database_encryption          = var.database_encryption
  default_max_pods_per_node    = var.default_max_pods_per_node
  enable_binary_authorization  = var.enable_binary_authorization
  enable_intranode_visibility  = var.enable_intranode_visibility

  initial_node_count              = var.initial_node_count
  remove_default_node_pool        = var.remove_default_node_pool
  deploy_using_private_endpoint   = var.deploy_using_private_endpoint
  enable_private_endpoint         = var.enable_private_endpoint
  enable_private_nodes            = var.enable_private_nodes
  master_ipv4_cidr_block          = var.master_ipv4_cidr_block
  enable_vertical_pod_autoscaling = var.enable_vertical_pod_autoscaling

  #  enable_shielded_nodes             = var.enable_shielded_nodes
  identity_namespace         = var.identity_namespace
  istio                      = var.istio
  node_metadata              = var.node_metadata
  node_pools_taints          = var.node_pools_taints
  pod_security_policy_config = var.pod_security_policy_config
  #  release_channel                   = var.release_channel
  resource_usage_export_dataset_id = var.resource_usage_export_dataset_id
  sandbox_enabled                  = var.sandbox_enabled
}

data "google_client_config" "default" {
}

