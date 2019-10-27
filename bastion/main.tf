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

module "iap_bastion" {
  source = "terraform-google-modules/bastion-host/google"
  version = 0.1.0

  project = data.terraform_remote_state.service-project.project_id
  region = var.region
  zone = "${var.region}-a"
  network = data.terraform_remote_state.env.outputs.network_self_link
  subnet = data.terraform_remote_state.subnets.outputs.subnets_self_links[0]
  members = [
    "group:${data.terraform_remote_state.service-project.outputs.group_email}",
  ]
}
