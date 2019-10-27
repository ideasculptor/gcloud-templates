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
  subnets_map = zipmap(data.terraform_remote_state.public_subnets.outputs.subnets_names,
                       data.terraform_remote_state.public_subnets.outputs.subnets_self_links)

  admin_subnets = [
    for subnet in data.terraform_remote_state.public_subnets.outputs.subnets_names:
    local.subnets_map[subnet] if length(regexall("^.*-admin$", subnet)) > 0
  ]
}

module "iap_bastion" {
  source = "terraform-google-modules/bastion-host/google"

  project = data.terraform_remote_state.service-project.outputs.project_id
  region = var.region
  zone = "${var.region}-a"
  network = data.terraform_remote_state.env.outputs.network_self_link
  subnet = local.admin_subnets[0]
  members = [
    "group:${data.terraform_remote_state.service-project.outputs.group_email}",
  ]
}
