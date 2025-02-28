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
  path = "oidc"
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
  policy    = file("${path.module}/templates/namespace_admin_policy.hcl")
}

resource "vault_identity_group" "namespace_admin_internal" {
  namespace        = vault_namespace.default.path
  name             = data.okta_group.namespace_admin.name
  member_group_ids = [vault_identity_group.namespace_admin_external.id]
  policies         = [vault_policy.namespace_admin.name]
}
