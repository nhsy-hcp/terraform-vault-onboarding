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
  for_each = var.namespaces
  name     = "ns-admin-${each.key}"
  policy   = data.vault_policy_document.namespace_admin[each.key].hcl
}

resource "vault_quota_rate_limit" "global" {
  name = "global"
  path = ""
  #  block_interval = 0
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
