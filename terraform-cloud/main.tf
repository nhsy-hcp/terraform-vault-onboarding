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
  name     = "namespace-admin-${each.key}"
  policy   = data.vault_policy_document.namespace_admin[each.key].hcl
}
