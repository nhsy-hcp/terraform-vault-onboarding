resource "vault_policy" "tfc_admin" {
  count     = var.vault_namespace != null ? 1 : 0
  namespace = var.vault_namespace
  name      = var.vault_policy_name
  policy    = file("${path.module}/../../policies/tfc_namespace_admin_policy.hcl")
}

resource "vault_jwt_auth_backend" "tfc" {
  count              = var.vault_namespace != null ? 1 : 0
  namespace          = var.vault_namespace
  type               = "jwt"
  path               = var.vault_auth_path
  description        = "JWT auth backend for Terraform Cloud"
  bound_issuer       = "https://app.terraform.io"
  oidc_discovery_url = "https://app.terraform.io"

  tune {
    default_lease_ttl = var.vault_default_lease_ttl
    max_lease_ttl     = var.vault_max_lease_ttl
    token_type        = var.token_type
  }
}

resource "vault_jwt_auth_backend_role" "tfc_admin" {
  namespace       = var.vault_namespace
  backend         = var.vault_namespace != null ? vault_jwt_auth_backend.tfc[0].path : var.vault_auth_path
  bound_audiences = ["vault.workload.identity"]
  bound_claims = {
    sub = format("organization:%s:project:%s:workspace:%s:run_phase:*",
      var.tfc_organization,
      var.tfc_project,
    var.tfc_workspace)
  }
  bound_claims_type = "glob"
  role_type         = "jwt"
  role_name         = var.vault_auth_role
  token_type        = var.vault_token_type
  token_policies    = [var.vault_policy_name]
  token_ttl         = var.token_ttl
  token_max_ttl     = var.token_max_ttl
  user_claim        = "terraform_full_workspace"
}
