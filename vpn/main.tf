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

module "vpn" {
  source = "git@github.com:terraform-google-modules/terraform-google-vpn.git"
  # source  = "terraform-google-modules/vpn/google"
  # version = "~> 2.0"

  project_id    = data.terraform_remote_state.vpc.outputs.project_id
  network       = data.terraform_remote_state.vpc.outputs.network_name
  region        = var.region
  gateway_name       = "vpn-gw-us-ce1-static"
  tunnel_name_prefix = "vpn-tn-us-ce1-static"
  shared_secret      = "sams_secret_network"
  tunnel_count       = 1
  peer_ips           = ["98.232.147.100"]

  route_priority     = 1000
  remote_subnet      = ["10.10.254.0/24"]
}

