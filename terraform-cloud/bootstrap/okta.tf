locals {
  # Fetch okta user ids for each group
  vault_admin_member_ids = [for k, v in var.okta_users : okta_user.default[k].id if contains(v.groups, "vault-admin")]
  vault_user_member_ids  = [for user in okta_user.default : user.id]

  #TODO: Refactor to get the member ids for the group memberships
  vault_app1_admin_member_ids = [for k, v in var.okta_users : okta_user.default[k].id if contains(v.groups, "vault-app1-admin")]
  vault_app2_admin_member_ids = [for k, v in var.okta_users : okta_user.default[k].id if contains(v.groups, "vault-app2-admin")]
  vault_app3_admin_member_ids = [for k, v in var.okta_users : okta_user.default[k].id if contains(v.groups, "vault-app3-admin")]

  okta_audiences = concat(
    tolist(okta_auth_server.default.audiences),
    [okta_app_oauth.default.client_id]
  )

  # Fetch okta group ids
  #  okta_group_ids = [for group in okta_group.default : group.id]

}

# Create okta mgmt groups
resource "okta_group" "mgmt" {
  for_each = toset(var.okta_mgmt_groups)
  name     = each.value
}

# Create okta namespace groups
resource "okta_group" "namespace" {
  for_each = toset(var.okta_namespace_groups)
  name     = each.value
}

# Create okta users
resource "okta_user" "default" {
  for_each   = var.okta_users
  email      = each.key
  first_name = each.value.first_name
  last_name  = each.value.last_name
  login      = each.key
  password   = each.value.password
}

# Create group memberships
resource "okta_group_memberships" "vault_admin" {
  group_id = okta_group.mgmt["vault-admin"].id
  users    = local.vault_admin_member_ids
}

# Add each user to vault-user group for okta app assignment
resource "okta_group_memberships" "vault_user" {
  group_id = okta_group.mgmt["vault-user"].id
  users    = local.vault_user_member_ids
}


resource "okta_group_memberships" "vault_app1_admin" {
  group_id = okta_group.namespace["vault-app1-admin"].id
  users    = local.vault_app1_admin_member_ids
}

resource "okta_group_memberships" "vault_app2_admin" {
  group_id = okta_group.namespace["vault-app2-admin"].id
  users    = local.vault_app2_admin_member_ids
}

resource "okta_group_memberships" "vault_app3_admin" {
  group_id = okta_group.namespace["vault-app3-admin"].id
  users    = local.vault_app3_admin_member_ids
}

resource "okta_auth_server" "default" {
  audiences   = ["api://vault"]
  description = "Vault Authorization Server"
  name        = "vault"
  issuer_mode = "ORG_URL"
  status      = "ACTIVE"
}

resource "okta_auth_server_claim" "default" {
  auth_server_id          = okta_auth_server.default.id
  name                    = "groups"
  value                   = "vault-"
  value_type              = "GROUPS"
  group_filter_type       = "STARTS_WITH"
  claim_type              = "IDENTITY"
  scopes                  = ["profile"]
  always_include_in_token = true
}

resource "okta_auth_server_policy" "default" {
  description      = "Policy for Authorization Server"
  name             = "vault"
  auth_server_id   = okta_auth_server.default.id
  priority         = 1
  client_whitelist = [okta_app_oauth.default.client_id]
  status           = "ACTIVE"
}

resource "okta_auth_server_policy_rule" "default" {
  name            = "vault"
  auth_server_id  = okta_auth_server.default.id
  policy_id       = okta_auth_server_policy.default.id
  priority        = 1
  group_whitelist = [okta_group.mgmt["vault-user"].id]
  scope_whitelist = ["openid", "profile"]

  grant_type_whitelist = [
    "client_credentials",
    "authorization_code",
    "implicit"
  ]
}

resource "okta_app_oauth" "default" {
  label          = "HashiCorp Vault OIDC"
  type           = "web"
  grant_types    = ["authorization_code", "implicit", "refresh_token"]
  response_types = ["id_token", "code"]

  redirect_uris = [
    "${var.vault_address}/ui/vault/auth/${var.okta_auth_path}/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]

  groups_claim {
    filter_type = "STARTS_WITH"
    name        = "groups"
    type        = "FILTER"
    value       = "vault-"
  }
}

# Assign the vault app to the vault-user group
resource "okta_app_group_assignment" "default" {
  app_id   = okta_app_oauth.default.id
  group_id = okta_group.mgmt["vault-user"].id
}

resource "okta_app_oauth_api_scope" "default" {
  app_id = okta_app_oauth.default.id
  issuer = var.okta_org_url
  scopes = ["okta.groups.read", "okta.users.read.self"]
}

data "vault_policy_document" "okta_vault_admin" {
  rule {
    path         = "*"
    capabilities = ["sudo", "read", "create", "update", "delete", "list", "patch"]
  }
}

resource "vault_policy" "okta_vault_admin" {
  name   = "okta-vault-admin"
  policy = data.vault_policy_document.okta_vault_admin.hcl
}

resource "vault_identity_group" "vault_user" {
  name              = okta_group.mgmt["vault-user"].name
  type              = "external"
  external_policies = true
}

resource "vault_identity_group_alias" "vault_user" {
  name           = okta_group.mgmt["vault-user"].name
  mount_accessor = vault_jwt_auth_backend.okta.accessor
  canonical_id   = vault_identity_group.vault_user.id
}

resource "vault_identity_group" "vault_admin" {
  name              = okta_group.mgmt["vault-admin"].name
  type              = "external"
  external_policies = true
}

resource "vault_identity_group_alias" "vault_admin" {
  name           = okta_group.mgmt["vault-admin"].name
  mount_accessor = vault_jwt_auth_backend.okta.accessor
  canonical_id   = vault_identity_group.vault_admin.id
}

resource "vault_identity_group_policies" "vault_admin" {
  group_id  = vault_identity_group.vault_admin.id
  exclusive = false
  policies  = ["okta-vault-admin"]
}

resource "vault_jwt_auth_backend" "okta" {
  description        = "Okta OIDC Auth Method"
  path               = var.okta_auth_path
  type               = "oidc"
  default_role       = "okta-group"
  bound_issuer       = okta_auth_server.default.issuer
  oidc_discovery_url = var.okta_org_url
  oidc_client_id     = okta_app_oauth.default.client_id
  oidc_client_secret = okta_app_oauth.default.client_secret

  tune {
    default_lease_ttl = "8h"
    max_lease_ttl     = "24h"
    token_type        = "default-service"
  }
}

resource "vault_jwt_auth_backend_role" "okta_group" {
  backend               = vault_jwt_auth_backend.okta.path
  role_type             = vault_jwt_auth_backend.okta.type
  role_name             = "okta-group"
  bound_audiences       = local.okta_audiences
  bound_claims_type     = "glob"
  allowed_redirect_uris = okta_app_oauth.default.redirect_uris
  user_claim            = "sub"
  oidc_scopes           = ["profile", "groups"]
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
