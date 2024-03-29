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

data "terraform_remote_state" "env" {
  backend = "gcs"
  config = {
    bucket = var.terraform_state_bucket
    prefix = "${var.terraform_state_prefix}/${var.parent_path}/${var.environment}/environment"
  }
}

data "terraform_remote_state" "public_subnets" {
  backend = "gcs"
  config = {
    bucket = var.terraform_state_bucket
    prefix = "${var.terraform_state_prefix}/${var.parent_path}/${var.environment}/${var.region}/${var.environment}/${var.public_subnets_path}"
  }
}

data "terraform_remote_state" "backend_subnets" {
  backend = "gcs"
  config = {
    bucket = var.terraform_state_bucket
    prefix = "${var.terraform_state_prefix}/${var.parent_path}/${var.environment}/${var.region}/${var.environment}/${var.backend_subnets_path}"
  }
}


data "terraform_remote_state" "service_project" {
  backend = "gcs"
  config = {
    bucket = var.terraform_state_bucket
    prefix = "${var.terraform_state_prefix}/${var.parent_path}/${var.environment}/service-project"
  }
}

