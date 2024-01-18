data "vault_policy_document" "self_token_admin" {
  # Allow tokens to query themselves
  rule {
    path         = "auth/token/lookup-self"
    capabilities = ["read"]
  }
  # Allow tokens to renew themselves
  rule {
    path         = "auth/token/renew-self"
    capabilities = ["update"]
  }
  # Allow tokens to revoke themselves
  rule {
    path         = "auth/token/revoke-self"
    capabilities = ["update"]
  }
}

resource "vault_policy" "self_token_admin" {
  name   = "self-token-admin"
  policy = data.vault_policy_document.self_token_admin.hcl
}

data "vault_policy_document" "github_admin" {
  rule {
    path         = "sys/namespaces"
    capabilities = ["list"]
  }
  rule {
    path         = "sys/namespaces/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }
  # List existing policies
  rule {
    path         = "sys/policies"
    capabilities = ["read", "list"]
  }
  # Create and manage ACL policies
  rule {
    path         = "sys/policies/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }

  #  rule {
  #    path         = "secret/*"
  #    capabilities = ["create", "read", "update", "delete", "list"]
  #    description  = "Allow all access to secrets"
  #  }

  #  # Needed for terraform vault provider child token creation
  #  rule {
  #    path         = "auth/token/create"
  #    capabilities = ["create", "read", "update", "delete", "list"]
  #  }
}

resource "vault_policy" "github_admin" {
  name   = "github-admin"
  policy = data.vault_policy_document.github_admin.hcl
}

resource "vault_jwt_auth_backend" "github" {
  description        = "JWT auth backend for GitHub Actions"
  path               = var.vault_auth_mount_path
  bound_issuer       = "https://token.actions.githubusercontent.com"
  oidc_discovery_url = "https://token.actions.githubusercontent.com"

  tune {
    default_lease_ttl = var.default_lease_ttl
    max_lease_ttl     = var.max_lease_ttl
    token_type        = var.token_type
  }
}

resource "vault_jwt_auth_backend_role" "github_admin" {
  backend         = vault_jwt_auth_backend.github.path
  bound_audiences = ["https://github.com/${var.github_organization}"]
  bound_claims = {
    repository = "${var.github_organization}/${var.github_repository}"
  }
  role_type      = "jwt"
  role_name      = "github-admin"
  token_policies = [vault_policy.github_admin.name]
  #  token_ttl      = 60 * 5
  user_claim = "workflow"
}