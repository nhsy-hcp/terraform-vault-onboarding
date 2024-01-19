resource "vault_namespace" "default" {
  for_each = var.namespaces
  path     = each.value.name
  custom_metadata = {
    created-by = "Terraform onboarding provisioner"
  }
}

data "vault_policy_document" "namespace_admin" {
  for_each = var.namespaces
  rule {
    path         = "sys/namespaces"
    capabilities = ["list"]
  }
  rule {
    path         = "sys/namespaces/${each.value.name}"
    capabilities = ["list", "read"]
  }
  rule {
    path         = "sys/namespaces/${each.value.name}/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }
}

resource "vault_policy" "namespace_admin" {
  for_each = var.namespaces
  name     = "namespace-admin-${each.value.name}"
  policy   = data.vault_policy_document.namespace_admin[each.key].hcl
}
