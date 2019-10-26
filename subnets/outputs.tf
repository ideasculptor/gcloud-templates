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

output "network_name" {
  value       = module.subnets.network_name
  description = "The name of the VPC being modified/created"
}

output "network_self_link" {
  value       = module.subnets.network_self_link
  description = "The URI of the VPC being modified/created"
}

output "svpc_host_project_id" {
  value       = module.subnets.svpc_host_project_id
  description = "Shared VPC host project id."
}

output "subnets_names" {
  value       = module.subnets.subnets_names
  description = "The names of the subnets being created"
}

output "subnets_ips" {
  value       = module.subnets.subnets_ips
  description = "The IPs and CIDRs of the subnets being created"
}

output "subnets_self_links" {
  value       = module.subnets.subnets_self_links
  description = "The self-links of subnets being created"
}

output "subnets_regions" {
  value       = module.subnets.subnets_regions
  description = "The region where the subnets will be created"
}

output "subnets_private_access" {
  value       = module.subnets.subnets_private_access
  description = "Whether the subnets will have access to Google API's without a public IP"
}

output "subnets_flow_logs" {
  value       = module.subnets.subnets_flow_logs
  description = "Whether the subnets will have VPC flow logs enabled"
}

output "subnets_secondary_ranges" {
  value       = module.subnets.subnets_secondary_ranges
  description = "The secondary ranges associated with these subnets"
}

output "routes" {
  value       = module.subnets.routes
  description = "The routes associated with this VPC"
}

