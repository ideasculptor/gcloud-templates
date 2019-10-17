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

variable "root_node" {
  description = "Root node for the new hierarchy, either 'organizations/org_id' or 'folders/folder_id'."
  type        = string
}

variable "billing_account_id" {
  type = string
}

variable "org_id" {
  type = string
}

variable "credentials" {
  type = string
  default = ""
}

variable "impersonate_service_account" {
  type = string
  default = ""
}

variable "root_folder_name" {
  description = "Name of the root folder to create"
  default = "Reference Infrastructure"
}

variable "create_group" {
  default = "true"
}

variable "group_name" {
  default = "refarch-root-admin"
}

variable "group_role" {
  default = "roles/editor"
}

variable "root_project_id_prefix" {
  default = "refarch-root"
}

variable "random_project_id" {
  default = "true"
}

variable "root_project_name" {
  default = "Reference Architecture Root"
}

variable "sa_group" {
  default = "refarch-root-admin@ideasculptor.com"
}

variable "project_services" {
  description = "Service APIs enabled by default in new projects."
  default = [
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-api.googleapis.com",
  ]
}

variable "bucket_name" {
  default = "refarch_root_tf_state"
}

variable "bucket_location" {
  default = "us-west1"
}

