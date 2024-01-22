resource "vault_namespace" "default" {
  path = var.namespace
  custom_metadata = {
    created-by = "Terraform onboarding provisioner"
  }
}

data "vault_policy_document" "namespace_admin" {
  rule {
    path         = "sys/namespaces"
    capabilities = ["list"]
  }
  rule {
    path         = "sys/namespaces/${var.namespace}"
    capabilities = ["list", "read"]
  }
  rule {
    path         = "sys/namespaces/${var.namespace}/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }
}

resource "vault_policy" "namespace_admin" {
  name   = "namespace-admin-${var.namespace}"
  policy = data.vault_policy_document.namespace_admin.hcl
}
