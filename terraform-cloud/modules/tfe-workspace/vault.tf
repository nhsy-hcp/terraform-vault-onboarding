resource "vault_jwt_auth_backend_role" "tfc_admin" {
  backend         = var.vault_auth_path
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
  token_type        = "service"
  token_policies = [
    "default",
    var.vault_policy,
  ]
  token_ttl     = 300
  token_max_ttl = 3600
  user_claim    = "terraform_full_workspace"
}