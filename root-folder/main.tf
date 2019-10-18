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
terraform { 
  required_version = ">= 0.12"
  backend "gcs" {}
}

provider "google" {
  version = "~> 2.7.0"
  scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

provider "google-beta" {
  version = "~> 2.7.0"
  scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

provider "gsuite" {
  credentials = var.gsuite_credentials
  impersonated_user_email = var.impersonate_gsuite_user
  version = "~> 0.1.12"
  oauth_scopes = [
    "https://www.googleapis.com/auth/admin.directory.group",
    "https://www.googleapis.com/auth/admin.directory.user",
    "https://www.googleapis.com/auth/admin.directory.userschema",
  ]
}

locals {
  group_name = "${var.infrastructure_short_name}${var.group_name_suffix}"
  root_project_id_prefix = "${var.infrastructure_short_name}${var.root_project_id_suffix}"
  sa_group = "${var.infrastructure_short_name}${var.sa_group_suffix}"
  bucket_name = "${var.infrastructure_short_name}${var.bucket_name_suffix}"
  logs_bucket_name = "${var.infrastructure_short_name}${var.logs_bucket_name_suffix}"
}

# A folder to serve as the root of the infrastructure
module "root-folder" {
  source            = "terraform-google-modules/folders/google"
  version           = "2.0.0"
  parent            = var.root_node
  names             = [var.root_folder_name]
}

# The root project for infrastructure
module "root-project" {
#  source                  = "terraform-google-modules/project-factory/google//modules/gsuite_enabled"
#  version                 = "3.3.1"
  source                  = "git@github.com:ideasculptor/terraform-google-project-factory.git//modules/gsuite_enabled?ref=pip3_group_name"

  folder_id               = module.root-folder.id
  billing_account         = var.billing_account_id
  create_group            = var.create_group
  group_name              = local.group_name
  group_role              = var.group_role
  project_id              = local.root_project_id_prefix
  random_project_id       = var.random_project_id
  name                    = var.root_project_name
  org_id                  = var.organization
  sa_group                = local.sa_group
  default_service_account = "delete"
  lien                    = "true"

  activate_apis           = var.project_services

  bucket_name             = local.bucket_name
  bucket_project          = local.root_project_id_prefix
  bucket_location         = var.bucket_location

  credentials_path        = var.gsuite_credentials
  pip3_extra_flags        = "--user"
}

module "folder-iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"

  # Why is this necessary, module authors?  The resource returns the value,
  # how about an output to match?
  folders = [regex("folders/(.+)", module.root-folder.id)[0]]
  folders_num = 1

  mode = "additive"
  bindings_num = var.folder_roles_num
  bindings = zipmap(var.folder_roles, [for s in var.folder_roles : [ "group:${module.root-project.group_email}" ]])
}

module "org-iam" {
  source  = "terraform-google-modules/iam/google//modules/organizations_iam"

  # Why is this necessary, module authors?  The resource returns the value,
  # how about an output to match?
  organizations = [var.organization]
  organizations_num = 1

  mode = "additive"
  bindings_num = var.org_roles_num
  bindings = zipmap(var.org_roles, [for s in var.org_roles : [ "group:${module.root-project.group_email}" ]])
}

resource "gsuite_group_member" "admin_group_member" {
  count = var.admin_members_num

  group = module.root-project.group_email
  email = element(var.admin_members, count.index)
  role  = "MEMBER"
}

module "logs-project" {
#  source                  = "terraform-google-modules/project-factory/google//modules/gsuite_enabled"
#  version                 = "3.3.1"
  source                  = "git@github.com:ideasculptor/terraform-google-project-factory.git//modules/gsuite_enabled?ref=pip3_group_name"

  folder_id               = module.root-folder.id
  billing_account         = var.billing_account_id
  group_name              = module.root-project.group_name
  group_role              = var.group_role
  project_id              = "${local.root_project_id_prefix}-logs"
  random_project_id       = var.random_project_id
  name                    = var.log_project_name
  org_id                  = var.organization
  sa_group                = local.sa_group
  default_service_account = "delete"
  lien                    = "true"

  activate_apis           = concat(var.project_services, ["storage-component.googleapis.com"])

  bucket_name             = local.logs_bucket_name
  bucket_project          = "${local.root_project_id_prefix}-logs"
  bucket_location         = var.bucket_location

  impersonate_service_account = module.root-project.service_account_email
  pip3_extra_flags        = "--user"
}

resource "google_storage_bucket_iam_member" "log_service" {
  bucket = module.logs-project.project_bucket_name[0]
  role = "roles/storage.objectCreator"
  member = "group:cloud-storage-analytics@google.com"
}

module "log_export" {
  source                 = "terraform-google-modules/log-export/google"
  destination_uri        = "storage.googleapis.com/${module.logs-project.project_bucket_name[0]}"
  filter                 = "severity >= ERROR"
  log_sink_name          = "root_project_logsink"
  parent_resource_id     = module.root-project.project_id
  parent_resource_type   = "project"
  unique_writer_identity = "true"
}

resource "google_storage_bucket_iam_member" "logs_storage_sink_member" {
  bucket = module.logs-project.project_bucket_name[0]
  role   = "roles/storage.objectCreator"
  member = module.log_export.writer_identity
}

resource "google_project_usage_export_bucket" "usage_report_export" {
  project     = module.root-project.project_id
  bucket_name = module.logs-project.project_bucket_name[0]
  prefix      = "usage/${local.root_project_id_prefix}"
}
