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

variable "terraform_state_bucket" {
  type = string
}

variable "terraform_state_prefix" {
  type = string
}

variable "parent_path" {
  type = string
}

variable "parent_template" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "shared_vpc_host" {
  type = string
  default = "false"
}

variable "create_network" {
  type = string
  default = "false"
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

