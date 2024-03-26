resource "vault_policy" "tfc_admin" {
  name = "tfc-admin"
  #  policy = data.vault_policy_document.tfc_admin.hcl
  policy = file("${path.module}/templates/tfc_admin_policy.hcl")
}

resource "vault_jwt_auth_backend" "tfc" {
  description        = "JWT auth backend for Terraform Cloud"
  path               = var.vault_auth_path
  bound_issuer       = "https://app.terraform.io"
  oidc_discovery_url = "https://app.terraform.io"

  tune {
    default_lease_ttl = var.default_lease_ttl
    max_lease_ttl     = var.max_lease_ttl
    token_type        = var.token_type
  }
}

resource "vault_jwt_auth_backend_role" "tfc_admin" {
  backend         = vault_jwt_auth_backend.tfc.path
  bound_audiences = ["vault.workload.identity"]
  bound_claims = {
    sub = format("organization:%s:project:%s:workspace:%s:run_phase:*",
      var.tfc_organization,
      var.tfc_project,
    var.tfc_workspace)
  }
  bound_claims_type = "glob"
  role_type         = "jwt"
  role_name         = var.vault_role
  token_policies = [
    "default",
    vault_policy.tfc_admin.name,
  ]
  token_ttl  = 60 * 5
  user_claim = "terraform_full_workspace"
}