output "namespace" {
  value = var.namespace
}

output "rbac_delegation" {
  value = data.okta_group.rbac
}
