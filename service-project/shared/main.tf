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
  # Why is this necessary, module authors?  The resource returns the value,
  # how about an output to match?
  folder_id         = regex("folders/(.+)", data.terraform_remote_state.parent.outputs.folder_id)[0]
  project_name      = "${var.project_short_name} svc - ${data.terraform_remote_state.parent.outputs.infrastructure_short_name}"
  group_name        = "refarch-${var.project_short_name}-svc-admin"
  project_id_prefix = "refarch-${var.project_short_name}-svc"
  sa_group          = "${local.group_name}@${data.terraform_remote_state.parent.outputs.domain}"
}

module "project" {
  source = "terraform-google-modules/project-factory/google//modules/gsuite_enabled"
  #  source                  = "git@github.com:ideasculptor/terraform-google-project-factory.git//modules/gsuite_enabled?ref=multiple_host_networks"

  folder_id               = local.folder_id
  billing_account         = var.billing_account_id
  create_group            = var.create_group
  group_name              = local.group_name
  group_role              = var.group_role
  project_id              = local.project_id_prefix
  random_project_id       = var.random_project_id
  name                    = local.project_name
  org_id                  = var.organization
  sa_group                = local.sa_group
  default_service_account = "delete"
  lien                    = "true"
  auto_create_network     = "false"
  activate_apis           = var.project_services

  usage_bucket_name   = data.terraform_remote_state.parent.outputs.logs_bucket_name
  usage_bucket_prefix = "usage/${local.project_id_prefix}"

  credentials_path = var.gsuite_credentials
  #  pip3_extra_flags        = "--user"

  shared_vpc_enabled = "true"
  shared_vpc         = data.terraform_remote_state.dev.outputs.project_id
}

module "org-iam" {
  source = "terraform-google-modules/iam/google//modules/organizations_iam"

  # Why is this necessary, module authors?  The resource returns the value,
  # how about an output to match?
  organizations     = [var.organization]
  organizations_num = 1

  mode         = "additive"
  bindings_num = var.org_roles_num
  bindings = zipmap(
    var.org_roles,
    [for s in var.org_roles : ["group:${module.project.group_email}"]]
  )
}

module "folder-iam" {
  source = "terraform-google-modules/iam/google//modules/folders_iam"

  folders     = [local.folder_id]
  folders_num = 1

  mode         = "additive"
  bindings_num = var.folder_roles_num
  bindings = zipmap(
    var.folder_roles,
    [for s in var.folder_roles : ["group:${module.project.group_email}"]]
  )
}

module "projects-iam" {
  source = "terraform-google-modules/iam/google//modules/projects_iam"

  projects     = [module.project.project_id]
  projects_num = 1

  mode         = "additive"
  bindings_num = var.project_roles_num
  bindings = zipmap(
    var.project_roles,
    [for s in var.project_roles : ["group:${module.project.group_email}"]]
  )
}

resource "gsuite_group_member" "admin_group_member" {
  count = var.admin_members_num

  group = module.project.group_email
  email = element(var.admin_members, count.index)
  role  = "MEMBER"
}

