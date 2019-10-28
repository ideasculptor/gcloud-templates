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

output "service_account" {
  description = "The email for the service account created for the bastion host"
  value       = module.bastion.service_account
}

output "hostname" {
  description = "Host name of the bastion"
  value       = module.bastion.hostname
}

output "ip_address" {
  description = "Internal IP address of the bastion host"
  value       = module.bastion.ip_address
}

output "self_link" {
  description = "Self link of the bastion host"
  value       = module.bastion.self_link
}
