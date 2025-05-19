locals {
  # Fetch okta user ids for each group
  vault_admin_member_ids = [for k, v in var.okta_users : okta_user.default[k].id if contains(v.groups, "vault-admin")]
  vault_user_member_ids  = [for user in okta_user.default : user.id]

  vault_namespace_member_ids = {
    for group in var.okta_namespace_groups :
    group => [
      for user, details in var.okta_users :
      okta_user.default[user].id if contains(details.groups, group)
    ]
  }
}

resource "okta_group_memberships" "vault_namespaces" {
  for_each = local.vault_namespace_member_ids
  group_id = okta_group.namespace[each.key].id
  users    = each.value
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
    format("%s/ui/vault/auth/${var.okta_auth_path}/oidc/callback", var.vault_address),
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
  issuer = "https://${var.okta_org_name}.${var.okta_base_url}"
  scopes = ["okta.groups.read", "okta.users.read.self"]
}
