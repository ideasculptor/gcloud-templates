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

variable "environment" {
  description = "Name of the environment to create"
}

variable "region" {
  description = "Id of the region to create bastion within"
}

variable "public_subnets_path" {
  type    = string
  default = "public_subnets"
}

variable "backend_subnets_path" {
  type    = string
  default = "backend_subnets"
}

