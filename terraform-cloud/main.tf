#module "namespaces" {
#  source            = "./modules/namespace"
#  for_each          = var.namespaces
#  namespace         = each.key
#  description       = each.value.description
#  admin_group_id    = lookup(each.value, "admin_group_id")
#  quota_rate_limit  = lookup(each.value, "quota_rate_limit")
#  quota_lease_count = lookup(each.value, "quota_lease_count")
#}
module "app1" {
  source            = "./modules/namespace"
  namespace         = "app1"
  description       = "app1 namespace"
  admin_group_id    = "00gendqnq81ZCXhGl5d7"
  quota_lease_count = 101
  quota_rate_limit  = 102
}

#resource "vault_namespace" "default" {
#  for_each = var.namespaces
#  path     = each.key
#  custom_metadata = {
#    created-by  = "Terraform onboarding provisioner"
#    description = each.value.description
#  }
#}

#resource "vault_policy" "namespace_admin" {
#  for_each  = var.namespaces
#  namespace = each.key
#  name      = "namespace-admin"
#  policy    = file("templates/namespace_admin_policy.hcl")
#
#  depends_on = [
#    vault_namespace.default
#  ]
#}

#data "vault_policy_document" "namespace_rbac" {
#  for_each = var.namespaces
#  # Create and manage namespace ACL policies
#  rule {
#    path         = "${each.key}/sys/policies/acl/*"
#    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
#  }
#  # List namespace ACL policies
#  rule {
#    path         = "${each.key}/sys/policies/acl"
#    capabilities = ["list"]
#  }
#  # Create and manage namespace identities
#  rule {
#    path         = "${each.key}/identity/*"
#    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
#  }
#  # List namespace identities
#  rule {
#    path         = "${each.key}/identity"
#    capabilities = ["list"]
#  }
#}

#resource "vault_policy" "namespace_rbac" {
#  for_each = var.namespaces
#  name     = "namespace-rbac-${each.key}"
#  policy   = data.vault_policy_document.namespace_rbac[each.key].hcl
#
#}

resource "vault_quota_rate_limit" "global" {
  name     = "global"
  path     = ""
  interval = 30
  rate     = 10000
}

#resource "vault_quota_rate_limit" "namespace" {
#  for_each = var.namespaces
#  name     = each.key
#  path     = "${each.key}/"
#  interval = 30
#  rate     = lookup(each.value, "quota_rate_limit", 1000)
#  depends_on = [
#    vault_namespace.default
#  ]
#}

#resource "vault_quota_lease_count" "namespace" {
#  for_each   = var.namespaces
#  name       = each.key
#  path       = "${each.key}/"
#  max_leases = lookup(each.value, "quota_lease_count", 10000)
#  depends_on = [
#    vault_namespace.default
#  ]
#}

## Delegate namespace group admin
#resource "vault_identity_group" "namespace_admin" {
#  for_each          = var.namespaces
#  namespace         = each.key
#  name              = lookup(each.value, "admin_group_id")
#  type              = "external"
#  external_policies = true
#
#  depends_on = [
#    vault_namespace.default
#  ]
#}

#resource "vault_identity_group_policies" "namespace_admin" {
#  for_each  = var.namespaces
#  namespace = each.key
#  group_id  = vault_identity_group.namespace_admin[each.key].id
#  exclusive = false
#  policies  = [vault_policy.namespace_admin[each.key].name]
#
#  depends_on = [
#    vault_namespace.default
#  ]
#}

#data "vault_auth_backend" "okta" {
#  path = "oidc"
#}
#
#resource "vault_identity_group_alias" "namespace_admin" {
#  for_each       = var.namespaces
#  name           = lookup(each.value, "admin_group_id")
#  mount_accessor = data.vault_auth_backend.okta.accessor
#  canonical_id   = vault_identity_group.namespace_admin[each.key].id
#
#  depends_on = [
#    vault_namespace.default
#  ]
#}
