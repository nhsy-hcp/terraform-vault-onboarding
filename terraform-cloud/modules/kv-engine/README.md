# kv-engine

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 4.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_mount.kv](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the KV engine | `string` | `"KV v2 secrets engine"` | no |
| <a name="input_max_versions"></a> [max\_versions](#input\_max\_versions) | Maximum number of versions to keep per secret | `number` | `10` | no |
| <a name="input_path"></a> [path](#input\_path) | Path to mount the KV engine (e.g., secret/) | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
