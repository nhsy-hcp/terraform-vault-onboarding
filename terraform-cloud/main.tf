resource "vault_namespace" "default" {
  for_each = var.namespaces
  path     = each.key
  custom_metadata = {
    created-by  = "Terraform onboarding provisioner"
    description = each.value.description
  }
}

data "vault_policy_document" "namespace_admin" {
  for_each = var.namespaces
  rule {
    path         = "sys/namespaces"
    capabilities = ["list"]
  }
  rule {
    path         = "sys/namespaces/${each.key}"
    capabilities = ["list", "read"]
  }
  rule {
    path         = "sys/namespaces/${each.key}/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }
}

resource "vault_policy" "namespace_admin" {
  for_each  = var.namespaces
  namespace = each.key
  name      = "namespace-admin-${each.key}"
  policy    = data.vault_policy_document.namespace_admin[each.key].hcl
}

resource "vault_quota_rate_limit" "global" {
  name = "global"
  path = ""
  interval = 30
  rate     = 10000
}

resource "vault_quota_rate_limit" "namespace" {
  for_each = var.namespaces
  name     = each.key
  path     = "${each.key}/"
  #  block_interval = 0
  interval = 30
  rate     = lookup(each.value, "quota_rate_limit", 1000)
}

resource "vault_quota_lease_count" "namespace" {
  for_each   = var.namespaces
  name       = each.key
  path       = "${each.key}/"
  max_leases = lookup(each.value, "quota_lease_count", 10000)
}

# Delegate namespace group admin
resource "vault_identity_group" "namespace_admin" {
  for_each          = var.namespaces
  namespace         = each.key
  name              = lookup(each.value, "admin_group_id")
  type              = "external"
  external_policies = true

  depends_on = [vault_namespace.default]
}

resource "vault_identity_group_policies" "namespace_admin" {
  for_each  = var.namespaces
  namespace = each.key
  group_id  = vault_identity_group.namespace_admin[each.key].id
  exclusive = false
  policies  = [vault_policy.namespace_admin[each.key].name]
}

data "vault_auth_backend" "okta" {
  path = "oidc"
}

resource "vault_identity_group_alias" "namespace_admin" {
  for_each       = var.namespaces
  name           = lookup(each.value, "admin_group_id")
  mount_accessor = data.vault_auth_backend.okta.accessor
  canonical_id   = vault_identity_group.namespace_admin[each.key].id
}
