resource "vault_namespace" "default" {
  path = var.namespace
  custom_metadata = {
    created-by  = "Terraform onboarding provisioner"
    description = var.description
  }
}

resource "vault_quota_rate_limit" "namespace" {
  name     = vault_namespace.default.path
  path     = "${var.namespace}/"
  interval = 30
  rate     = var.quota_rate_limit
}

resource "vault_quota_lease_count" "namespace" {
  name       = vault_namespace.default.path
  path       = "${var.namespace}/"
  max_leases = var.quota_lease_count
}

# Delegate namespace group admin
# https://developer.hashicorp.com/vault/tutorials/enterprise/namespaces
data "okta_group" "namespace_admin" {
  name = var.admin_group_name
}
data "vault_auth_backend" "okta" {
  path = var.okta_auth_path
}

resource "vault_identity_group" "namespace_admin_external" {
  name = "${data.okta_group.namespace_admin.name}-external"
  type = "external"
}

resource "vault_identity_group_alias" "namespace_admin_external" {
  name           = var.admin_group_name
  mount_accessor = data.vault_auth_backend.okta.accessor
  canonical_id   = vault_identity_group.namespace_admin_external.id
}

resource "vault_policy" "namespace_admin" {
  namespace = vault_namespace.default.path
  name      = "namespace-admin"
  policy    = file("${path.module}/../../policies/namespace_admin_policy.hcl")
}

resource "vault_identity_group" "namespace_admin_internal" {
  namespace        = vault_namespace.default.path
  name             = data.okta_group.namespace_admin.name
  member_group_ids = [vault_identity_group.namespace_admin_external.id]
  policies         = [vault_policy.namespace_admin.name]
}

data "okta_group" "rbac" {
  for_each = var.rbac_delegation
  name     = each.value.group_name
}


# RBAC for the namespace
resource "vault_identity_group" "rbac_external" {
  for_each = var.rbac_delegation
  name     = "${data.okta_group.rbac[each.key].name}-external"
  type     = "external"
  policies = ["default"]
}

resource "vault_identity_group_alias" "rbac_external" {
  for_each       = var.rbac_delegation
  name           = each.value.group_name
  mount_accessor = data.vault_auth_backend.okta.accessor
  canonical_id   = vault_identity_group.rbac_external[each.key].id
}

# resource "vault_policy" "rbac" {
#   for_each  = var.rbac_delegation
#   namespace = vault_namespace.default.path
#   name      = each.key
#   policy    = each.value.policy
# }

resource "vault_policy" "rbac" {
  for_each = { for p in local.rbac_policies : p.name => p }

  namespace = vault_namespace.default.path
  name      = each.value.name
  policy    = each.value.policy
}


# resource "vault_identity_group" "rbac_internal" {
#   for_each         = var.rbac_delegation
#   namespace        = vault_namespace.default.path
#   name             = data.okta_group.rbac[each.key].name
#   member_group_ids = [vault_identity_group.rbac_external[each.key].id]
#   policies         = [vault_policy.rbac[each.key].name]
# }
