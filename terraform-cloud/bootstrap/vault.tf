resource "vault_policy" "tfc_admin" {
  name = "tfc-admin"
  #  policy = data.vault_policy_document.tfc_admin.hcl
  policy = file("${path.module}/../policies/tfc_admin_policy.hcl")
}

resource "vault_jwt_auth_backend" "tfc" {
  type               = "jwt"
  path               = var.vault_auth_path
  description        = "JWT auth backend for Terraform Cloud"
  bound_issuer       = "https://app.terraform.io"
  oidc_discovery_url = "https://app.terraform.io"

  tune {
    default_lease_ttl = var.default_lease_ttl
    max_lease_ttl     = var.max_lease_ttl
    token_type        = var.token_type
  }
}
