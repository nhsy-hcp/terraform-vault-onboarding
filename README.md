# HCP Terraform Vault Integration

> **Disclaimer:** This project is provided for demonstration and learning purposes only. It is not intended for production use without proper security review, hardening, and customization for your specific environment.

This directory contains Terraform configurations for integrating HashiCorp Vault with HCP Terraform. It provides automated namespace provisioning, workspace management, and authentication setup for multi-tenant Vault environments.

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
│   ├── namespace/          # Vault namespace creation module
│   ├── workspace/          # HCP Terraform workspace + Vault integration module
│   └── kv-engine/          # KV secrets engine module
├── policies/               # Vault policy HCL files
├── scripts/                # Utility scripts for operations
├── docs/                   # Documentation
└── Taskfile.yml            # Task automation configuration
```

> **Architecture & Design:** See [Solution Design Documentation](./docs/solution-design.md) for detailed architecture, authentication flows, and design decisions.

## Prerequisites

- Terraform >= 1.12.0
- HashiCorp Vault server
- HCP Terraform organization and API token
- Okta organization and API token (for OIDC authentication)
- [Task](https://taskfile.dev/) (optional, for automation)

## Workflow

The configurations should be applied in the following order:

1. **Bootstrap**: Sets up initial HCP Terraform projects, workspaces, and Vault JWT authentication
2. **Namespace Root**: Configures the root Vault namespace with OIDC authentication and identity groups
3. **Namespace Vending**: Creates child namespaces for business units with standardized configurations
4. **Business Unit Namespaces**: Individual BU namespaces can be customized independently

## Bootstrap Demo Setup

The bootstrap phase creates demo resources in OKTA for testing and demonstration purposes. These resources include:

- **Demo Users**: Configurable test users with credentials (defined in `okta_users` variable)
- **Management Groups**:
  - `vault-admin` - Administrative access to Vault
  - `vault-user` - Standard user access to Vault
- **Business Unit Groups**: Namespace-specific groups for each business unit:
  - `vault-bu01-admin` - Business Unit 1 administrators
  - `vault-bu02-admin` - Business Unit 2 administrators
  - `vault-bu03-admin` - Business Unit 3 administrators
- **Group Memberships**: Automatic assignment of users to their designated groups
- **OKTA OAuth Application**: Vault OIDC integration application
- **OKTA Authorization Server**: Configured for Vault authentication with appropriate claims

**Note:** These resources are created for demonstration and testing purposes only. You can customize the demo users, groups, and memberships by editing the `okta_users`, `okta_mgmt_groups`, and `okta_namespace_groups` variables in your `bootstrap/terraform.tfvars` file.

## Pre-requisites Setup

### Environment Variables

These environment variables must be set before running the Bootstrap:

| Variable | Description |
|----------|-------------|
| `VAULT_ADDR` | Vault server address |
| `VAULT_TOKEN` | Vault authentication token |

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
| `tfc_organization` | Terraform Cloud organization name | `"example-tfc-org"` | Yes |
| `tfc_project` | TFC project name | `"vault-onboarding"` | Yes |
| `tfc_token` | TFC API token (sensitive) | `"your-tfc-api-token"` | Yes |
| `vault_address` | Vault server address for local access | `"http://127.0.0.1:8200"` | Yes |
| `vault_address_tfc_agent` | Vault server address for TFC agent | `"http://vault:8200"` | Yes |
| `okta_org_name` | OKTA organization name | `"your-okta-org-name"` | Yes |
| `okta_api_token` | OKTA API token (sensitive) | `"your-okta-api-token"` | Yes |
| `okta_mgmt_groups` | Management groups to create in OKTA | `["vault-admin", "vault-user"]` | Yes |
| `okta_namespace_groups` | Namespace-specific groups to create | `["vault-bu01-admin", ...]` | Yes |
| `okta_users` | Demo users to create with group memberships | See example file | Yes |

**Important:** Update all sensitive values (tokens, passwords) before applying the bootstrap configuration.

### Local HCP Terraform Agent Setup

To enable HCP Terraform workspaces to communicate with your local Vault instance, you need to run an agent in the same Docker network as Vault.

**Prerequisites:**
- Docker or Podman installed and running
- HCP Terraform organization with an agent pool configured
- Vault running in a Docker container

**Setup Steps:**

1. **Create an Agent Pool in HCP Terraform**:
   - Navigate to your HCP Terraform organization settings
   - Go to "Agents" section
   - Create a new agent pool and note the agent token

2. **Run the HCP Terraform agent container**:
   ```bash
   docker run -d \
     --name tfc-agent \
     --network vault-network \
     -e TFC_AGENT_TOKEN="your-agent-token" \
     -e TFC_AGENT_NAME="local-agent" \
     hashicorp/tfc-agent:latest
   ```

3. **Verify connectivity**:
   - The agent should appear as "idle" in your HCP Terraform agent pool
   - The agent can resolve the Vault container using the hostname `vault`
   - This corresponds to the `vault_address_tfc_agent` variable value: `http://vault:8200`

**Network Configuration:**
- Vault container must be accessible via hostname `vault` on port `8200`
- Both Vault and the HCP Terraform agent must be on the same Docker network
- The `vault_address_tfc_agent` variable in `terraform.tfvars` should use the container hostname

**Troubleshooting:**
- Verify network connectivity: `docker exec tfc-agent ping vault`
- Check agent logs: `docker logs tfc-agent`
- Ensure Vault is listening on `0.0.0.0:8200` inside the container, not just `127.0.0.1:8200`

## Usage

### Using Taskfile

The following Taskfile commands are available for working with this project:

**Plan bootstrap configuration:**
```bash
task bootstrap-plan
```
Reviews the changes that will be applied to bootstrap the infrastructure, including HCP Terraform projects, workspaces, and OKTA demo resources.

**Apply bootstrap configuration:**
```bash
task bootstrap-apply
```
Applies the bootstrap configuration to create the initial infrastructure setup.

**Validate all configurations:**
```bash
task validate
```
Validates the Terraform syntax and configuration across all modules (bootstrap, namespace-vending, namespace-root).

**Format all Terraform files:**
```bash
task lint
```
Formats all Terraform files in the repository according to standard conventions.

## Modules

### namespace

Creates a Vault namespace with:
- Namespace resource
- Admin and RBAC identity groups
- Quota rate limits and lease counts
- Namespace-specific policies

### workspace

Creates a HCP Terraform workspace integrated with Vault:
- HCP Terraform workspace resource
- Vault JWT auth backend role
- Workspace variables for Vault authentication
- Agent pool configuration (optional)

### kv-engine

Manages KV v2 secrets engines within a namespace.

## Authentication

### HCP Terraform to Vault

Uses JWT authentication with OIDC. Workspaces are configured with bound claims to receive Vault tokens scoped to their assigned namespace and policies.

### Okta to Vault

OIDC authentication is configured in the root namespace. Users authenticate via Okta and receive tokens based on their group membership.

## Adding a New Business Unit

1. Create a namespace definition in `namespace-vending/bu{XX}.tf`
2. Create a dedicated directory `namespace-bu{XX}/`
3. Add the required files:
  - `main.tf`
  - `providers.tf`
  - `variables.tf`
4. Apply namespace-vending first, then the business unit configuration

## Policies

Vault policy HCL files are stored in the `policies/` directory:

| Policy | Description |
|--------|-------------|
| `tfc_admin_policy.hcl` | Full admin access for TFC workspaces |
| `tfc_namespace_admin_policy.hcl` | Namespace-scoped admin access |
| `namespace_admin_policy.hcl` | Namespace administrator permissions |
| `okta_vault_admin_policy.hcl` | Okta-authenticated admin permissions |

## Notes

- Do not use a self-signed certificate for Vault TLS or an OIDC workflow will error on login.

## Additional Resources

- [Vault Provider Documentation](https://registry.terraform.io/providers/hashicorp/vault/latest/docs)
- [TFE Provider Documentation](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs)
- [Okta Provider Documentation](https://registry.terraform.io/providers/okta/okta/latest/docs)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
