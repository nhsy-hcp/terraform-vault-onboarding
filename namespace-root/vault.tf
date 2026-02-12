# resource "vault_policy" "tfc_admin" {
#   name = "tfc-admin"
#   #  policy = data.vault_policy_document.tfc_admin.hcl
#   policy = file("${path.module}/../templates/tfc_admin_policy.hcl")
# }

data "okta_auth_server" "default" {
  name = "vault"
}

data "okta_app_oauth" "default" {
  label = "HashiCorp Vault OIDC"
}

data "okta_group" "mgmt" {
  for_each = toset(var.okta_mgmt_groups)
  name     = each.value
}

resource "vault_identity_group" "vault_user" {
  name              = "${data.okta_group.mgmt["vault-user"].name}-external"
  type              = "external"
  external_policies = true
}

resource "vault_identity_group_alias" "vault_user" {
  name           = data.okta_group.mgmt["vault-user"].name
  mount_accessor = vault_jwt_auth_backend.okta.accessor
  canonical_id   = vault_identity_group.vault_user.id
}

resource "vault_identity_group" "vault_admin" {
  name              = "${data.okta_group.mgmt["vault-admin"].name}-external"
  type              = "external"
  external_policies = true
}

resource "vault_identity_group_alias" "vault_admin" {
  name           = data.okta_group.mgmt["vault-admin"].name
  mount_accessor = vault_jwt_auth_backend.okta.accessor
  canonical_id   = vault_identity_group.vault_admin.id
}

resource "vault_identity_group_policies" "vault_admin" {
  group_id  = vault_identity_group.vault_admin.id
  exclusive = false
  policies = [
    resource.vault_policy.vault_admin.name,
    resource.vault_policy.vault_admin_namespace.name
  ]
}

resource "vault_jwt_auth_backend" "okta" {
  description        = "Okta OIDC Auth Method"
  path               = var.okta_auth_path
  type               = "oidc"
  default_role       = "okta-group"
  bound_issuer       = data.okta_auth_server.default.issuer
  namespace_in_state = true
  oidc_discovery_url = data.okta_auth_server.default.issuer
  oidc_client_id     = data.okta_app_oauth.default.client_id
  oidc_client_secret = data.okta_app_oauth.default.client_secret

  tune {
    default_lease_ttl  = var.default_lease_ttl
    listing_visibility = "unauth"
    max_lease_ttl      = var.max_lease_ttl
    token_type         = var.token_type
  }
}

resource "vault_jwt_auth_backend_role" "okta_group" {
  backend               = vault_jwt_auth_backend.okta.path
  role_type             = vault_jwt_auth_backend.okta.type
  role_name             = "okta-group"
  bound_audiences       = local.okta_audiences
  bound_claims_type     = "glob"
  allowed_redirect_uris = data.okta_app_oauth.default.redirect_uris
  user_claim            = "email"
  oidc_scopes           = ["profile", "groups", "email"]
  groups_claim          = "groups"
  token_policies        = ["default"]

  claim_mappings = {
    email       = "email"
    name        = "name"
    given_name  = "first_name"
    middle_name = "middle_name"
    family_name = "last_name"
    okta_app_id = "aud"
    issuer      = "iss"
  }
}

resource "vault_policy" "vault_admin" {
  name   = "vault-admin"
  policy = file("./${path.module}/../policies/vault_admin_policy.hcl")
}

resource "vault_policy" "vault_admin_namespace" {
  name   = "vault-admin-namespace"
  policy = file("./${path.module}/../policies/vault_admin_namespace_policy.hcl")
}
