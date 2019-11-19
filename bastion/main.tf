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
  subnets_map = zipmap(
    data.terraform_remote_state.public_subnets.outputs.subnets_names,
    data.terraform_remote_state.public_subnets.outputs.subnets_self_links
  )

  admin_subnets = [
    for subnet in data.terraform_remote_state.public_subnets.outputs.subnets_names :
      local.subnets_map[subnet] if length(regexall("^.*-admin$", subnet)) > 0
  ]
}

data "template_file" "startup_script" {
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install -y tinyproxy
  EOF
}

module "bastion" {
#  source = "terraform-google-modules/bastion-host/google"
#  version = ">= 0.2.0"
  source = "git@github.com:terraform-google-modules/terraform-google-bastion-host.git"

  project        = data.terraform_remote_state.service_project.outputs.project_id
  host_project   = google_compute_route.bastion-egress.project
  network        = google_compute_route.bastion-egress.network
  region         = var.region
  zone           = "${var.region}-a"
  subnet         = local.admin_subnets[0]
  members        = [
    "group:${data.terraform_remote_state.service_project.outputs.group_email}",
  ]
  image_family   = var.image_family
  image_project  = var.image_project
  shielded_vm    = var.shielded_vm
  machine_type   = var.machine_type
  startup_script = data.template_file.startup_script.rendered
  tags           = var.tags
  labels         = var.labels
  random_role_id = true
}

resource "google_compute_route" "bastion-egress" {
  project          = data.terraform_remote_state.env.outputs.project_id
  network          = data.terraform_remote_state.env.outputs.network_self_link
  name             = "bastion-egress"
  description      = "Allow bastion to talk to the internet"
  tags             = var.tags
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
  priority         = "1000"
}

resource "google_compute_firewall" "ingress-bastion" {
  provider       = "google-beta"
  name           = "${var.environment}-ingress-bastion"
  description    = "Allow inbound traffic from bastion host"
  network        = data.terraform_remote_state.env.outputs.network_self_link
  project        = data.terraform_remote_state.env.outputs.project_id
  direction      = "INGRESS"
  enable_logging = true
  source_tags    = ["bastion"]

  dynamic "allow" {
    for_each = ["tcp", "udp", "icmp"]
    content {
      protocol = allow.value
    }
  }
}
