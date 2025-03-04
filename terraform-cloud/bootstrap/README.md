# bootstrap

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.0 |
| <a name="requirement_okta"></a> [okta](#requirement\_okta) | ~> 4.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_okta"></a> [okta](#provider\_okta) | 4.8.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 4.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_namespace-vending"></a> [namespace-vending](#module\_namespace-vending) | ./../modules/tfe-workspace | n/a |
| <a name="module_namespace_root"></a> [namespace\_root](#module\_namespace\_root) | ./../modules/tfe-workspace | n/a |

## Resources

| Name | Type |
|------|------|
| [okta_app_group_assignment.default](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/app_group_assignment) | resource |
| [okta_app_oauth.default](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/app_oauth) | resource |
| [okta_app_oauth_api_scope.default](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/app_oauth_api_scope) | resource |
| [okta_auth_server.default](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/auth_server) | resource |
| [okta_auth_server_claim.default](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/auth_server_claim) | resource |
| [okta_auth_server_policy.default](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/auth_server_policy) | resource |
| [okta_auth_server_policy_rule.default](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/auth_server_policy_rule) | resource |
| [okta_group.mgmt](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/group) | resource |
| [okta_group.namespace](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/group) | resource |
| [okta_group_memberships.vault_admin](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/group_memberships) | resource |
| [okta_group_memberships.vault_dev_admin](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/group_memberships) | resource |
| [okta_group_memberships.vault_prd_admin](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/group_memberships) | resource |
| [okta_group_memberships.vault_tst_admin](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/group_memberships) | resource |
| [okta_group_memberships.vault_user](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/group_memberships) | resource |
| [okta_user.default](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/user) | resource |
| [vault_jwt_auth_backend.tfc](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend) | resource |
| [vault_policy.tfc_admin](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_lease_ttl"></a> [default\_lease\_ttl](#input\_default\_lease\_ttl) | Default lease TTL for Vault tokens | `string` | `"10m"` | no |
| <a name="input_enable_tfc_agent_pool"></a> [enable\_tfc\_agent\_pool](#input\_enable\_tfc\_agent\_pool) | n/a | `bool` | `true` | no |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | Name of the GitHub organization. | `string` | n/a | yes |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | Name of the GitHub repository. | `string` | `"terraform-vault-onboarding"` | no |
| <a name="input_max_lease_ttl"></a> [max\_lease\_ttl](#input\_max\_lease\_ttl) | Maximum lease TTL for Vault tokens | `string` | `"30m"` | no |
| <a name="input_okta_api_token"></a> [okta\_api\_token](#input\_okta\_api\_token) | Okta API token | `string` | n/a | yes |
| <a name="input_okta_auth_path"></a> [okta\_auth\_path](#input\_okta\_auth\_path) | n/a | `string` | `"oidc"` | no |
| <a name="input_okta_base_url"></a> [okta\_base\_url](#input\_okta\_base\_url) | Okta base URL | `string` | `"okta.com"` | no |
| <a name="input_okta_mgmt_groups"></a> [okta\_mgmt\_groups](#input\_okta\_mgmt\_groups) | n/a | `list(string)` | <pre>[<br/>  "vault-admin",<br/>  "vault-user"<br/>]</pre> | no |
| <a name="input_okta_namespace_groups"></a> [okta\_namespace\_groups](#input\_okta\_namespace\_groups) | n/a | `list(string)` | `[]` | no |
| <a name="input_okta_org_name"></a> [okta\_org\_name](#input\_okta\_org\_name) | Okta organization name | `string` | n/a | yes |
| <a name="input_okta_users"></a> [okta\_users](#input\_okta\_users) | n/a | <pre>map(object({<br/>    first_name = string<br/>    last_name  = string<br/>    password   = string<br/>    groups     = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_tfc_organization"></a> [tfc\_organization](#input\_tfc\_organization) | Name of the TFC organization. | `string` | n/a | yes |
| <a name="input_tfc_project"></a> [tfc\_project](#input\_tfc\_project) | Name of the TFC project. | `string` | `"default project"` | no |
| <a name="input_tfc_token"></a> [tfc\_token](#input\_tfc\_token) | Terraform Cloud API token | `string` | n/a | yes |
| <a name="input_tfc_working_directory_prefix"></a> [tfc\_working\_directory\_prefix](#input\_tfc\_working\_directory\_prefix) | Working directory for the TFC workspace. | `string` | `"terraform-cloud"` | no |
| <a name="input_tfc_workspace_prefix"></a> [tfc\_workspace\_prefix](#input\_tfc\_workspace\_prefix) | Name of the TFC workspace. | `string` | `"terraform-vault-onboarding"` | no |
| <a name="input_token_type"></a> [token\_type](#input\_token\_type) | Token type for Vault tokens | `string` | `"default-service"` | no |
| <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address) | Vault API endpoint | `string` | n/a | yes |
| <a name="input_vault_address_tfc_agent"></a> [vault\_address\_tfc\_agent](#input\_vault\_address\_tfc\_agent) | Vault API endpoint for TFC agent | `string` | n/a | yes |
| <a name="input_vault_auth_path"></a> [vault\_auth\_path](#input\_vault\_auth\_path) | Mount path where JWT Auth will be configured | `string` | `"jwt/tfc"` | no |
| <a name="input_vault_auth_role_prefix"></a> [vault\_auth\_role\_prefix](#input\_vault\_auth\_role\_prefix) | Vault role name | `string` | `"tfc-admin"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
