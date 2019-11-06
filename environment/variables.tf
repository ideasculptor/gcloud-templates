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

variable "gsuite_credentials" {
  type = string
}

variable "impersonate_gsuite_user" {
  type = string
}

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

variable "billing_account_id" {
  type = string
}

variable "organization" {
  type = string
}

variable "environment" {
  description = "Name of the environment to create"
}

variable "create_group" {
  default = "true"
}

variable "group_role" {
  default = "roles/editor"
}

variable "random_project_id" {
  default = "true"
}

variable "project_services" {
  description = "Service APIs enabled by default in new projects."
  default = [
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "iap.googleapis.com",
    "logging.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-api.googleapis.com",
  ]
}

variable "admin_members_num" {
  default = 0
}

variable "admin_members" {
  type    = list(string)
  default = []
}

variable "org_roles" {
  default = ["roles/resourcemanager.organizationViewer"]
}

variable "org_roles_num" {
  default = 1
}

variable "folder_roles" {
  default = [
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/owner",
    "roles/billing.projectManager",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/servicemanagement.admin",
    "roles/serviceusage.serviceUsageAdmin",
  ]
}

variable "folder_roles_num" {
  default = 8
}
