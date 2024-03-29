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

variable "infrastructure_short_name" {
  type    = string
  default = "refarch"
}

variable "root_node" {
  description = "Root node for the new hierarchy, either 'organizations/org_id' or 'folders/folder_id'."
  type        = string
}

variable "billing_account_id" {
  type = string
}

variable "organization" {
  type = string
}

variable "impersonate_service_account" {
  type    = string
  default = ""
}

variable "root_folder_name" {
  description = "Name of the root folder to create"
  default     = "Reference Infrastructure"
}

variable "create_group" {
  default = "true"
}

variable "group_name_suffix" {
  default = "-root-admin"
}

variable "group_role" {
  default = "roles/editor"
}

variable "root_project_id_suffix" {
  default = "-root"
}

variable "random_project_id" {
  default = "true"
}

variable "root_project_name" {
  default = "Reference Infrastructure Root"
}

variable "log_project_name" {
  default = "Reference Infrastructure Logs"
}

variable "sa_group_suffix" {
  default = "-root-admin@ideasculptor.com"
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

variable "bucket_name_suffix" {
  default = "_root_tf_state"
}

variable "logs_bucket_name_suffix" {
  default = "_logs_ideascuptor"
}

variable "bucket_location" {
  default = "us-west1"
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
