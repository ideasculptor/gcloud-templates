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

output "internal_ranges" {
  description = "Internal ranges."
  value = module.firewall.internal_ranges
}

output "admin_ranges" {
  description = "Admin ranges data."
  value = module.firewall.admin_ranges
}

output "custom_ingress_allow_rules" {
  description = "Custom ingress rules with allow blocks."
  value = module.firewall.custom_ingress_allow_rules
}

output "custom_ingress_deny_rules" {
  description = "Custom ingress rules with deny blocks."
  value = module.firewall.custom_ingress_deny_rules
}

output "custom_egress_allow_rules" {
  description = "Custom egress rules with allow blocks."
  value = module.firewall.custom_egress_allow_rules
}

output "custom_egress_deny_rules" {
  description = "Custom egress rules with allow blocks."
  value = module.firewall.custom_egress_deny_rules
}

