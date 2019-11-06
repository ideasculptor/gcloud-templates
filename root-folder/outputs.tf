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

output "infrastructure_short_name" {
  value = var.infrastructure_short_name
}

output "folder_id" {
  value = module.root-folder.id
}

output "folder" {
  value = module.root-folder.folder
}

output "project_name" {
  value = module.root-project.project_name
}

output "project_id" {
  value = module.root-project.project_id
}

output "project_number" {
  value = module.root-project.project_number
}

output "domain" {
  value       = module.root-project.domain
  description = "The organization's domain"
}

output "group_email" {
  value       = module.root-project.group_email
  description = "The email of the created GSuite group with group_name"
}

output "group_name" {
  value       = module.root-project.group_name
  description = "The email of the created GSuite group with group_name"
}

output "service_account_id" {
  value       = module.root-project.service_account_id
  description = "The id of the default service account"
}

output "service_account_display_name" {
  value       = module.root-project.service_account_display_name
  description = "The display name of the default service account"
}

output "service_account_email" {
  value       = module.root-project.service_account_email
  description = "The email of the default service account"
}

output "service_account_name" {
  value       = module.root-project.service_account_name
  description = "The fully-qualified name of the default service account"
}

output "service_account_unique_id" {
  value       = module.root-project.service_account_unique_id
  description = "The unique id of the default service account"
}

output "project_bucket_self_link" {
  value       = module.root-project.project_bucket_self_link[0]
  description = "Project's bucket selfLink"
}

output "project_bucket_url" {
  value       = module.root-project.project_bucket_url[0]
  description = "Project's bucket url"
}

output "project_bucket_name" {
  value = module.root-project.project_bucket_name[0]
}

output "project_bucket_location" {
  value = var.bucket_location
}

output "logs_project_name" {
  value = module.logs-project.project_name
}

output "logs_project_id" {
  value = module.logs-project.project_id
}

output "logs_project_number" {
  value = module.logs-project.project_number
}

output "logs_group_email" {
  value = module.logs-project.group_email
}

output "logs_group_name" {
  value = module.logs-project.group_name
}

output "logs_service_account_id" {
  value = module.logs-project.service_account_id
}

output "logs_service_account_display_name" {
  value = module.logs-project.service_account_display_name
}

output "logs_service_account_email" {
  value = module.logs-project.service_account_email
}

output "logs_service_account_name" {
  value = module.logs-project.service_account_name
}

output "logs_service_account_unique_id" {
  value = module.logs-project.service_account_unique_id
}


output "logs_bucket_name" {
  value = module.logs-project.project_bucket_name[0]
}

output "logs_bucket_url" {
  value = module.logs-project.project_bucket_url[0]
}

output "logs_bucket_location" {
  value = var.bucket_location
}
