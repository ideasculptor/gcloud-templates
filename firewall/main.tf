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
  range_map = zipmap(data.terraform_remote_state.public_subnets.outputs.subnets_names,
  data.terraform_remote_state.public_subnets.outputs.subnets_ips)

  admin_ranges = [
    for range in data.terraform_remote_state.public_subnets.outputs.subnets_names :
    local.range_map[range] if length(regexall("^.*-admin$", range)) > 0
  ]

  all_ranges = concat(
    data.terraform_remote_state.public_subnets.outputs.subnets_ips,
    data.terraform_remote_state.backend_subnets.outputs.subnets_ips,
    [
      for range in flatten(data.terraform_remote_state.public_subnets.outputs.subnets_secondary_ranges) :
      range["ip_cidr_range"]
    ],
    [for range in flatten(data.terraform_remote_state.backend_subnets.outputs.subnets_secondary_ranges) :
      range["ip_cidr_range"]
    ]
  )
}

module "nat" {
  source        = "terraform-google-modules/cloud-nat/google"
  project_id    = data.terraform_remote_state.vpc.outputs.project_id
  region        = var.region
  create_router = "true"
  router        = "${var.environment}-cloud-nat"
  network       = data.terraform_remote_state.vpc.outputs.network_name
}

module "firewall" {
  source                  = "terraform-google-modules/network/google//modules/fabric-net-firewall"
  project_id              = data.terraform_remote_state.vpc.outputs.project_id
  network                 = data.terraform_remote_state.vpc.outputs.network_name
  admin_ranges            = local.admin_ranges
  admin_ranges_enabled    = true
  internal_ranges_enabled = true
  internal_ranges         = local.all_ranges
  ssh_source_ranges       = ["0.0.0.0/0"]
}

