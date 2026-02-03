# Terraform Vault Onboarding

> **Disclaimer:** This project is provided for demonstration and learning purposes only. It is not intended for production use without proper security review, hardening, and customization for your specific environment.

This directory contains Terraform configurations for integrating HCP Vault with HCP Terraform. It provides automated namespace provisioning, workspace management, and authentication setup for multi-tenant Vault environments.

## Directory Structure

```
terraform-vault-onboarding/
├── bootstrap/              # Initial HCP Terraform project and workspace setup
├── namespace-root/         # Root namespace configuration
├── namespace-vending/      # Automated namespace provisioning
├── namespace-bu01/         # Business Unit 1 namespace
├── namespace-bu02/         # Business Unit 2 namespace
├── namespace-bu03/         # Business Unit 3 namespace
├── modules/
│   ├── namespace/          # HCP Vault namespace creation module
│   ├── workspace/          # HCP Terraform workspace + HCP Vault integration module
│   └── kv-engine/          # KV secrets engine module
├── policies/               # HCP Vault policy HCL files
├── scripts/                # Utility scripts for operations
├── docs/                   # Documentation
└── Taskfile.yml            # Task automation configuration
```

> **Architecture & Design:** See [Solution Design Documentation](./docs/solution-design.md) for detailed architecture, authentication flows, and design decisions.

## Prerequisites

- Terraform >= 1.14.0
- HCP account (HashiCorp Cloud Platform)
- HCP Vault (HCP Vault Cluster)
- HCP Terraform organization and API token
- Okta organization and API token (for OIDC authentication)
- [Task](https://taskfile.dev/) (optional, for automation)

## Workflow

The configurations should be applied in the following order:

1. **Bootstrap**: Sets up the HCP HVN and HCP Vault Cluster, initial HCP Terraform projects, workspaces, and HCP Vault JWT authentication.
2. **Namespace Root**: Configures the root HCP Vault namespace with OIDC authentication and identity groups.
3. **Namespace Vending**: Creates child namespaces for business units with standardized configurations.
4. **Business Unit Namespaces**: Individual BU namespaces can be customized independently.

## Bootstrap Demo Setup

The bootstrap phase creates demo resources in OKTA for testing and demonstration purposes. It also handles the infrastructure setup on HCP:

- **HCP Networking**: Creates a HashiCorp Virtual Network (HVN).
- **HCP Vault**: Provisions a Vault cluster with randomized IDs for uniqueness.
- **Demo Users**: Configurable test users with credentials (defined in `okta_users` variable).
...
### Terraform Variables

Copy the example terraform variables file and update it with your values:

```bash
cp ./bootstrap/terraform.tfvars.example ./bootstrap/terraform.tfvars
```

Edit `./bootstrap/terraform.tfvars` and configure the following variables:

| Variable | Description | Example | Required |
|----------|-------------|---------|----------|
| `github_organization` | GitHub organization name | `"example-org"` | Yes |
| `github_repository` | Repository name | `"terraform-vault-onboarding"` | Yes |
| `tfc_organization` | HCP Terraform organization name | `"example-tfc-org"` | Yes |
| `tfc_project` | HCP Terraform project name | `"vault-onboarding"` | Yes |
| `tfc_token` | HCP Terraform API token (sensitive) | `"your-tfc-api-token"` | Yes |
| `hcp_project_id` | HCP Project ID | `"your-hcp-project-uuid"` | Yes |
| `okta_org_name` | OKTA organization name | `"your-okta-org-name"` | Yes |
| `okta_api_token` | OKTA API token (sensitive) | `"your-okta-api-token"` | Yes |
| `hcp_hvn_id` | HCP HVN identifier | `"vault-hvn"` | No (Default) |
| `hcp_vault_cluster_id` | HCP Vault cluster identifier | `"vault-cluster"` | No (Default) |
| `hcp_hvn_region` | AWS region for HCP HVN | `"eu-west-1"` | No (Default) |

**Note:** All HCP resource IDs are automatically suffixed with a random hex string to ensure global uniqueness.

### HCP Terraform Agent Setup (Optional)

HCP Terraform Agent pools are supported but disabled by default (`enable_tfc_agent_pool = false`). If your HCP Vault cluster is set to a private endpoint, you will need to run agents within a network that can reach the HCP HVN (e.g., via VPC Peering or Transit Gateway).

**Note:** The previous `vault_address_tfc_agent` variable is obsolete as HCP Vault provides a consistent public or private endpoint URL.

## Usage

### namespace

Creates a HCP Vault namespace with OIDC identity mapping and optional quotas.

```hcl
module "engineering_namespace" {
  source           = "./modules/namespace"
  namespace        = "engineering"
  description      = "Engineering Business Unit"
  admin_group_name = "okta-eng-admins"

  enable_quotas     = true
  quota_rate_limit  = 500
}
```

### workspace

Creates a HCP Terraform workspace integrated with HCP Vault using JWT authentication.

```hcl
module "engineering_workspace" {
  source = "./modules/workspace"

  tfc_organization      = "my-org"
  tfc_project           = "vault-onboarding"
  tfc_workspace         = "engineering-infra"
  tfc_working_directory = "terraform/engineering"

  vault_address         = "https://vault.example.com"
  vault_namespace       = module.engineering_namespace.namespace
}
```

### kv-engine

Manages KV v2 secrets engines within a namespace.

```hcl
module "engineering_secrets" {
  source    = "./modules/kv-engine"
  namespace = module.engineering_namespace.namespace
  path      = "app-secrets"
}
```

## Authentication

### HCP Terraform to HCP Vault

Uses JWT authentication with OIDC. Workspaces are configured with bound claims to receive HCP Vault tokens scoped to their assigned namespace and policies.

### Okta to HCP Vault

OIDC authentication is configured in the root HCP Vault namespace. Users authenticate via Okta and receive tokens based on their group membership.

## Adding a New Business Unit

1. Create a namespace definition in `namespace-vending/bu{XX}.tf`
2. Create a dedicated directory `namespace-bu{XX}/`
3. Add the required files:
  - `main.tf`
  - `providers.tf`
  - `variables.tf`
4. Apply namespace-vending first, then the business unit configuration

## Policies

HCP Vault policy HCL files are stored in the `policies/` directory:

| Policy | Description |
|--------|-------------|
| `tfc_admin_policy.hcl` | Full admin access for HCP Terraform workspaces |
| `tfc_namespace_admin_policy.hcl` | Namespace-scoped admin access |
| `namespace_admin_policy.hcl` | Namespace administrator permissions |
| `vault_admin_policy.hcl` | Vault Admin ACL policy |

## Notes

- Do not use a self-signed certificate for HCP Vault TLS or an OIDC workflow will error on login.

## Development

### Local Testing (CI Simulation)

You can run the GitHub Actions CI workflow locally using [act](https://github.com/nektos/act). This requires Docker to be installed and running.

```bash
task test-ci
```

### Linting & Formatting

The project uses `pre-commit` and `tflint` for code quality.

- **Pre-commit**: Runs automatically on commit if installed (`pre-commit install`). Can be run manually via `task lint`.
- **Formatting**: Enforced via `terraform fmt`.
- **Linting**: Uses `tflint` with recursive checks across all modules.

## Additional Resources

- [Vault Provider Documentation](https://registry.terraform.io/providers/hashicorp/vault/latest/docs)
- [TFE Provider Documentation](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs)
- [Okta Provider Documentation](https://registry.terraform.io/providers/okta/okta/latest/docs)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
