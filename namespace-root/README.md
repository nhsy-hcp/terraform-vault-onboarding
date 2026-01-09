# namespace-root

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.12.0 |
| <a name="requirement_okta"></a> [okta](#requirement\_okta) | ~> 6.5 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 5.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_okta"></a> [okta](#provider\_okta) | 4.14.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 4.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_identity_group.vault_admin](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group) | resource |
| [vault_identity_group.vault_user](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group) | resource |
| [vault_identity_group_alias.vault_admin](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_alias) | resource |
| [vault_identity_group_alias.vault_user](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_alias) | resource |
| [vault_identity_group_policies.vault_admin](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_policies) | resource |
| [vault_jwt_auth_backend.okta](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend) | resource |
| [vault_jwt_auth_backend_role.okta_group](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_policy.okta_vault_admin](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_quota_rate_limit.global](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/quota_rate_limit) | resource |
| [okta_app_oauth.default](https://registry.terraform.io/providers/okta/okta/latest/docs/data-sources/app_oauth) | data source |
| [okta_auth_server.default](https://registry.terraform.io/providers/okta/okta/latest/docs/data-sources/auth_server) | data source |
| [okta_group.mgmt](https://registry.terraform.io/providers/okta/okta/latest/docs/data-sources/group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_lease_ttl"></a> [default\_lease\_ttl](#input\_default\_lease\_ttl) | Default lease TTL for Vault tokens | `string` | `"10m"` | no |
| <a name="input_max_lease_ttl"></a> [max\_lease\_ttl](#input\_max\_lease\_ttl) | Maximum lease TTL for Vault tokens | `string` | `"30m"` | no |
| <a name="input_okta_auth_path"></a> [okta\_auth\_path](#input\_okta\_auth\_path) | n/a | `string` | `"oidc"` | no |
| <a name="input_okta_base_url"></a> [okta\_base\_url](#input\_okta\_base\_url) | Okta base URL | `string` | `"okta.com"` | no |
| <a name="input_okta_mgmt_groups"></a> [okta\_mgmt\_groups](#input\_okta\_mgmt\_groups) | n/a | `list(string)` | <pre>[<br/>  "vault-admin",<br/>  "vault-user"<br/>]</pre> | no |
| <a name="input_okta_org_name"></a> [okta\_org\_name](#input\_okta\_org\_name) | Okta organization name | `string` | n/a | yes |
| <a name="input_token_type"></a> [token\_type](#input\_token\_type) | Token type for Vault tokens | `string` | `"default-service"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
