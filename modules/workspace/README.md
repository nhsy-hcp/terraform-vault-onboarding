<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.73 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 5.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.73.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 5.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_variable.default](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.enable_vault_provider_auth](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.okta_api_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.okta_base_url](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.okta_org_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tfc_vault_address](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tfc_vault_auth_method](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tfc_vault_auth_path](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tfc_vault_namespace](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tfc_vault_run_role](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tfc_vault_workload_identity_audience](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tfe_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_workspace.default](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |
| [tfe_workspace_settings.agent_pool](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace_settings) | resource |
| [vault_jwt_auth_backend.tfc](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend) | resource |
| [vault_jwt_auth_backend_role.tfc_admin](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_policy.tfc_admin](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [tfe_agent_pool.default](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/agent_pool) | data source |
| [tfe_github_app_installation.default](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/github_app_installation) | data source |
| [tfe_project.default](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_tfc_agent_pool"></a> [enable\_tfc\_agent\_pool](#input\_enable\_tfc\_agent\_pool) | n/a | `bool` | `false` | no |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | Name of the GitHub organization. | `string` | n/a | yes |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | Name of the GitHub repository. | `string` | n/a | yes |
| <a name="input_okta_api_token"></a> [okta\_api\_token](#input\_okta\_api\_token) | Okta API token | `string` | `null` | no |
| <a name="input_okta_base_url"></a> [okta\_base\_url](#input\_okta\_base\_url) | Okta base URL | `string` | `"okta.com"` | no |
| <a name="input_okta_org_name"></a> [okta\_org\_name](#input\_okta\_org\_name) | Okta organization name | `string` | `null` | no |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | Version of Terraform to use | `string` | `">= 1.11.0"` | no |
| <a name="input_tfc_organization"></a> [tfc\_organization](#input\_tfc\_organization) | Name of the TFC organization. | `string` | n/a | yes |
| <a name="input_tfc_project"></a> [tfc\_project](#input\_tfc\_project) | Name of the TFC project. | `string` | n/a | yes |
| <a name="input_tfc_token"></a> [tfc\_token](#input\_tfc\_token) | TFC API token | `string` | `null` | no |
| <a name="input_tfc_variables"></a> [tfc\_variables](#input\_tfc\_variables) | Map of additional TFC variables | <pre>map(object({<br/>    value     = string<br/>    category  = optional(string, "terraform")<br/>    sensitive = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_tfc_vault_namespace"></a> [tfc\_vault\_namespace](#input\_tfc\_vault\_namespace) | Vault namespace to configure in TFC (TFC\_VAULT\_NAMESPACE). If null, defaults to vault\_namespace. | `string` | `null` | no |
| <a name="input_tfc_working_directory"></a> [tfc\_working\_directory](#input\_tfc\_working\_directory) | Working directory for the TFC workspace. | `string` | n/a | yes |
| <a name="input_tfc_workspace"></a> [tfc\_workspace](#input\_tfc\_workspace) | Name of the TFC workspace. | `string` | n/a | yes |
| <a name="input_token_max_ttl"></a> [token\_max\_ttl](#input\_token\_max\_ttl) | Maximum lease TTL for Vault tokens | `string` | `600` | no |
| <a name="input_token_ttl"></a> [token\_ttl](#input\_token\_ttl) | Default lease TTL for Vault tokens | `string` | `300` | no |
| <a name="input_token_type"></a> [token\_type](#input\_token\_type) | Token type for Vault tokens | `string` | `"service"` | no |
| <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address) | Vault API endpoint | `string` | n/a | yes |
| <a name="input_vault_auth_method"></a> [vault\_auth\_method](#input\_vault\_auth\_method) | Vault auth method for TFC | `string` | `"jwt"` | no |
| <a name="input_vault_auth_path"></a> [vault\_auth\_path](#input\_vault\_auth\_path) | Mount path where JWT Auth will be configured | `string` | n/a | yes |
| <a name="input_vault_auth_role"></a> [vault\_auth\_role](#input\_vault\_auth\_role) | Vault role name | `string` | n/a | yes |
| <a name="input_vault_default_lease_ttl"></a> [vault\_default\_lease\_ttl](#input\_vault\_default\_lease\_ttl) | Default lease TTL for Vault tokens | `string` | `"10m"` | no |
| <a name="input_vault_max_lease_ttl"></a> [vault\_max\_lease\_ttl](#input\_vault\_max\_lease\_ttl) | Maximum lease TTL for Vault tokens | `string` | `"30m"` | no |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | Vault namespace where resources (JWT backend, roles) will be created. If null, uses the provider's default namespace. | `string` | `null` | no |
| <a name="input_vault_policy_name"></a> [vault\_policy\_name](#input\_vault\_policy\_name) | Vault policy name | `string` | `"tfc-namespace-admin"` | no |
| <a name="input_vault_token_type"></a> [vault\_token\_type](#input\_vault\_token\_type) | Token type for Vault tokens | `string` | `"service"` | no |
| <a name="input_vault_workload_identity_audience"></a> [vault\_workload\_identity\_audience](#input\_vault\_workload\_identity\_audience) | Vault workload identity audience | `string` | `"vault.workload.identity"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
