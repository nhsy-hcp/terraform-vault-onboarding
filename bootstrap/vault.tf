resource "random_id" "hcp" {
  byte_length = 4
}

resource "hcp_hvn" "vault" {
  hvn_id         = "${var.hcp_hvn_id}-${var.hcp_hvn_region}-${random_id.hcp.hex}"
  cloud_provider = "aws"
  region         = var.hcp_hvn_region
  cidr_block     = var.hcp_hvn_cidr_block
}

resource "hcp_vault_cluster" "vault" {
  cluster_id      = "${var.hcp_vault_cluster_id}-${random_id.hcp.hex}"
  hvn_id          = hcp_hvn.vault.hvn_id
  tier            = var.hcp_vault_tier
  public_endpoint = var.hcp_vault_public_endpoint

}

resource "hcp_vault_cluster_admin_token" "vault" {
  cluster_id = hcp_vault_cluster.vault.cluster_id
}



resource "vault_policy" "tfc_admin" {
  name = var.vault_policy
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
