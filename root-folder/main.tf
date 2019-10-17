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
  credentials = var.credentials
  version = "~> 2.7.0"
  scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

provider "google-beta" {
  credentials = var.credentials
  version = "~> 2.7.0"
  scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

provider "gsuite" {
  credentials = var.credentials
  impersonated_user_email = "sgendler@ideasculptor.com"
  version = "~> 0.1.12"
  oauth_scopes = [
    "https://www.googleapis.com/auth/admin.directory.group",
    "https://www.googleapis.com/auth/admin.directory.user",
    "https://www.googleapis.com/auth/admin.directory.userschema",
  ]
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
  source                  = "git@github.com:ideasculptor/terraform-google-project-factory.git//modules/gsuite_enabled?ref=gsuite_impersonate_sa"
#  version                 = "3.3.1"

  folder_id               = module.root-folder.id
  billing_account         = var.billing_account_id
  create_group            = var.create_group
  group_name              = var.group_name
  group_role              = var.group_role
  project_id              = var.root_project_id_prefix
  random_project_id       = var.random_project_id
  name                    = var.root_project_name
  org_id                  = var.org_id
  sa_group                = var.sa_group
  default_service_account = "delete"
  lien                    = "true"

  activate_apis           = var.project_services

  bucket_name             = var.bucket_name
  bucket_project          = var.root_project_id_prefix
  bucket_location         = var.bucket_location

  credentials_path        = var.credentials
  # impersonate_service_account = var.impersonate_service_account
}

module "folder-iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"

  # Why is this necessary, module authors?  The resource returns the value,
  # how about an output to match?
  folders = [regex("folders/(.+)", module.root-folder.id)[0]]
  folders_num = 1

  mode = "additive"
  bindings_num = 3
  bindings = {
    "roles/resourcemanager.folderEditor" = [
      "group:${module.root-project.group_email}",
    ]
    "roles/resourcemanager.projectCreator" = [
      "group:${module.root-project.group_email}",
    ]
    "roles/owner" = [
      "group:${module.root-project.group_email}",
    ]
  }
}

