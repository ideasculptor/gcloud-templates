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
  subnet_name = "${var.environment}-${var.region}-public-1"
}

module "subnets" {
  # source          = "terraform-google-modules/network/google"
  # version         = "~> 1.4.0"
  source = "git@github.com:terraform-google-modules/terraform-google-network.git?ref=master"

  project_id   = data.terraform_remote_state.env.outputs.project_id
  network_name = data.terraform_remote_state.env.outputs.network_name

  shared_vpc_host                        = var.shared_vpc_host
  create_network                         = var.create_network
  routing_mode                           = var.routing_mode
  auto_create_subnetworks                = var.auto_create_subnetworks
  delete_default_internet_gateway_routes = var.delete_default_internet_gateway_routes

  subnets = [for subnet in var.subnets : {
    subnet_name           = "${var.environment}-${var.region}-${subnet.subnet_name}"
    subnet_ip             = subnet.subnet_ip
    subnet_region         = var.region
    subnet_private_access = lookup(subnet, "subnet_private_access", "false")
    subnet_flow_logs      = lookup(subnet, "subnet_flow_logs", "true")
  }]

  secondary_ranges = { for range_name, secondary_list in var.secondary_ranges : "${var.environment}-${var.region}-${range_name}" => [for range_val in secondary_list : {
    range_name    = "${var.environment}-${var.region}-${range_name}-${range_val.range_name}"
    ip_cidr_range = range_val.ip_cidr_range
  }] }

  routes = [for route in var.routes : {
    name                   = "${data.terraform_remote_state.env.outputs.network_name}-${route.name}"
    description            = lookup(route, "description", "")
    destination_range      = route.destination_range
    tags                   = route.tags
    next_hop_internet      = lookup(route, "next_hop_internet", "false")
    next_hop_ip            = lookup(route, "next_hop_ip", "")
    next_hop_instance      = lookup(route, "next_hop_instance", "")
    next_hop_instance_zone = lookup(route, "next_hop_instance_zone", "")
    next_hop_vpn_tunnel    = lookup(route, "next_hop_vpn_tunnel", "")
    priority               = lookup(route, "priority", "1000")
  }]
}

