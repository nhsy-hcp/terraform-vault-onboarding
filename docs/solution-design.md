# Solution Design: HCP Terraform & HCP Vault Integration

## Overview

This solution provides automated provisioning and management of HCP Vault infrastructure integrated with HCP Terraform. It implements a multi-tenant namespace architecture that enables isolated secret management for multiple tenants while maintaining centralized administration and consistent security policies.

### Key Capabilities

- Automated HCP Vault namespace provisioning for tenants
- HCP Terraform workspace creation with HCP Vault authentication
- OIDC integration with Okta for human access
- JWT-based authentication for HCP Terraform workspaces
- Policy-based access control with least privilege
- Modular, reusable Terraform components

## Architecture

### High-Level Component Diagram

```
┌────────────────────────────────────────────────────────────────┐
│                         HCP Terraform                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  Bootstrap   │  │ Namespace    │  │  BU Workspace│          │
│  │  Workspace   │  │  Vending     │  │  (tn001)      │          │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │
│         │                  │                  │                │
│         │ JWT Auth         │ JWT Auth         │ JWT Auth       │
└─────────┼──────────────────┼──────────────────┼────────────────┘
          │                  │                  │
          ▼                  ▼                  ▼
┌────────────────────────────────────────────────────────────────┐
│                           HCP Vault                            │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Root Namespace                                          │  │
│  │  - JWT Auth Backend (HCP Terraform)                      │  │
│  │  - OIDC Auth Backend (Okta)                              │  │
│  │  - Admin Policies                                        │  │
│  └────────────────────┬─────────────────────────────────────┘  │
│                       │                                        │
│         ┌─────────────┴─────────────┬──────────────┐           │
│         ▼                           ▼              ▼           │
│  ┌──────────────┐          ┌──────────────┐  ┌──────────────┐  │
│  │ Namespace:   │          │ Namespace:   │  │ Namespace:   │  │
│  │   tn001       │          │   tn002       │  │   tn003       │  │
│  │              │          │              │  │              │  │
│  │ - KV Store   │          │ - KV Store   │  │ - KV Store   │  │
│  │ - Policies   │          │ - Policies   │  │ - Policies   │  │
│  │ - Groups     │          │ - Groups     │  │ - Groups     │  │
│  └──────────────┘          └──────────────┘  └──────────────┘  │
└────────────────────────────────────────────────────────────────┘
          ▲
          │ OIDC Auth
          │
┌─────────┴──────────┐
│       Okta         │
│  - Users           │
│  - Groups          │
│  - Custom Claims   │
└────────────────────┘
```

### Component Relationships

```
Bootstrap (Root)
    │
    ├── Creates JWT Auth Backend
    ├── Creates HCP Terraform Workspaces (namespace-root, namespace-vending)
    └── Configures Okta OAuth App
        │
        ▼
Namespace Root
    │
    ├── Configures OIDC Auth (Okta)
    └── Creates Root-Level Policies
        │
        ▼
Namespace Vending
    │
    ├── Creates Child Namespaces (tn001, tn002, tn003)
    ├── Provisions HCP Terraform Workspaces per BU
    └── Configures Namespace-Specific Policies
        │
        ▼
Tenant Namespaces (tn001, tn002, tn003)
    │
    └── Custom Resources per BU (KV engines, additional policies)
```

## Core Components

### 1. Bootstrap Module

**Purpose:** Initialize foundational infrastructure

**Location:** `bootstrap/`

**Key Resources:**
- HCP Vault JWT authentication backend for HCP Terraform
- Okta OAuth application and authorization server
- HCP Terraform workspaces for `namespace-root` and `namespace-vending`
- Admin policies for HCP Terraform workspaces

**Responsibilities:**
- Configure HCP Vault HCP Terraform authentication
- Set up Okta integration
- Create initial HCP Terraform workspaces
- Establish admin access patterns

### 2. Namespace Root

**Purpose:** Configure root HCP Vault namespace

**Location:** `namespace-root/`

**Key Resources:**
- OIDC authentication method (Okta)
- Root-level identity groups
- Okta user and group mappings

**Responsibilities:**
- Enable human access to HCP Vault via Okta
- Configure identity-based access control
- Establish root namespace policies

### 3. Namespace Vending

**Purpose:** Automated tenant namespace provisioning

**Location:** `namespace-vending/`

**Key Resources:**
- Child HCP Vault namespaces (one per BU)
- HCP Terraform workspaces for each BU namespace
- Namespace-specific policies
- RBAC delegation configurations

**Responsibilities:**
- Create isolated namespaces per tenant
- Provision HCP Terraform workspaces with HCP Vault integration
- Configure namespace-level policies
- Set up delegated administration

### 4. Tenant Namespaces

**Purpose:** Per-BU customization and resource management

**Location:** `namespace-tn001/`, `namespace-tn002/`, `namespace-tn003/`

**Key Resources:**
- KV v2 secrets engines
- Custom policies
- Additional auth methods (if needed)

**Responsibilities:**
- Manage BU-specific secrets
- Customize policies for BU requirements
- Configure BU-specific integrations

## Reusable Modules

### namespace Module

**Location:** `modules/namespace/`

**Inputs:**
- `namespace` - Namespace name
- `description` - Namespace description
- `admin_group_name` - Admin group for the namespace
- `quota_rate_limit` - Rate limit quota
- `rbac_delegation` - Map of RBAC delegations

**Outputs:**
- `namespace` - Created namespace name

**Purpose:** Creates a HCP Vault namespace with quotas, identity groups, and policies

### workspace Module

**Location:** `modules/workspace/`

**Inputs:**
- `tfc_workspace` - Workspace name
- `tfc_project` - HCP Terraform project name
- `tfc_organization` - HCP Terraform org name
- `tfc_working_directory` - Working directory in repo
- `vault_address` - HCP Vault server URL
- `vault_auth_path` - JWT auth mount path
- `vault_auth_role` - Role name for workspace
- `vault_namespace` - Target HCP Vault namespace (optional)
- `github_organization` - GitHub org name
- `github_repository` - GitHub repo name

**Outputs:**
- `workspace_id` - HCP Terraform workspace ID

**Purpose:** Creates a HCP Terraform workspace with HCP Vault authentication configured via JWT

### kv-engine Module

**Location:** `modules/kv-engine/`

**Inputs:**
- `path` - Mount path for KV engine
- `namespace` - Target HCP Vault namespace
- `max_versions` - Maximum secret versions to retain

**Purpose:** Manages KV v2 secrets engine mounts

## Authentication & Authorization

### HCP Terraform to HCP Vault (JWT)

**Flow:**

```
┌─────────────────────────┐
│ HCP Terraform Workspace │
│ (Terraform Run)         │
└────────┬────────────────┘
         │ 1. Request HCP Vault token
         │    (with JWT from HCP Terraform)
         ▼
┌─────────────────────────────┐
│ HCP Vault JWT Auth Backend  │
│ - Validates JWT             │
│ - Checks bound claims       │
│ - Issues HCP Vault token    │
└────────┬────────────────────┘
         │ 2. HCP Vault token
         │    (scoped to policies)
         ▼
┌──────────────────────────┐
│ HCP Terraform Workspace  │
│ Uses token to            │
│ manage HCP Vault         │
└──────────────────────────┘
```

**Configuration:**

1. **JWT Auth Backend** (configured in `bootstrap/vault.tf`):
   - Mount path: `jwt/tfc`
   - OIDC Discovery URL: `https://app.terraform.io`
   - Bound audience: `vault.workload.identity`

2. **JWT Auth Roles** (one per workspace):
   - Bound claims: `terraform_organization_name`, `terraform_workspace_name`
   - Token policies: Scoped to workspace needs
   - Token TTL: Defined by `default_lease_ttl` and `max_lease_ttl`

3. **Workspace Variables** (set by workspace module):
   - `HCP_TERRAFORM_VAULT_PROVIDER_AUTH=true`
   - `HCP_TERRAFORM_VAULT_ADDR` - HCP Vault server address
   - `HCP_TERRAFORM_VAULT_NAMESPACE` - Target namespace (if applicable)
   - `HCP_TERRAFORM_VAULT_RUN_ROLE` - Role name for authentication
   - `HCP_TERRAFORM_VAULT_AUTH_PATH` - JWT backend mount path

**Security:**
- Tokens are short-lived (configurable TTL)
- Bound claims ensure only specific workspaces can assume roles
- Policies grant least-privilege access
- No static credentials stored in HCP Terraform

### Okta to HCP Vault (OIDC)

**Flow:**

```
┌─────────────┐
│   User      │
└──────┬──────┘
       │ 1. Authenticate
       ▼
┌──────────────────┐
│   Okta           │
│ - Verify creds   │
│ - Return ID token│
└──────┬───────────┘
       │ 2. ID token + custom claims
       ▼
┌─────────────────────────────┐
│ HCP Vault OIDC Auth Backend │
│ - Validate token            │
│ - Map groups                │
│ - Issue HCP Vault token     │
└──────┬──────────────────────┘
       │ 3. HCP Vault token
       │    (with group policies)
       ▼
┌─────────────┐
│   User      │
│ Access HCP Vault │
└─────────────┘
```

**Configuration:**

1. **Okta OAuth Application** (configured in `bootstrap/okta.tf`):
   - Authorization server with custom claims
   - Groups claim: `groups`
   - Application type: Web
   - Redirect URIs: HCP Vault callback URLs

2. **HCP Vault OIDC Auth** (configured in `namespace-root/vault.tf`):
   - OIDC discovery URL: Okta authorization server
   - Bound audiences: Okta client ID
   - Group claims: `groups`

3. **Identity Groups** (mapped to Okta groups):
   - `vault-admin` - Full administrative access
   - `vault-user` - Read-only access
   - BU-specific groups (e.g., `vault-tn001-admin`)

**Security:**
- OIDC tokens are validated cryptographically
- Group membership determines policy assignment
- MFA enforced via Okta policies
- Session duration controlled by HCP Vault token TTL

## Policy Model

### Policy Hierarchy

```
Root Namespace Policies
    │
    ├── tfc-admin-policy (HCP Terraform workspace admin access)
    ├── okta-vault-admin-policy (Okta admin users)
    └── namespace-admin-policy (Namespace-level admin)
        │
        ▼
Namespace-Specific Policies (per BU)
    │
    ├── {bu}-kv-read (Read-only KV access)
    ├── {bu}-kv-write (Write KV access)
    └── {bu}-admin (Full namespace admin)
```

### Policy Scoping

**Root-Level Policies:**
- Applied to HCP Terraform bootstrap workspace
- Applied to Okta admin groups
- Broad access across all namespaces

**Namespace-Level Policies:**
- Scoped to specific namespace path
- Applied to BU-specific workspaces
- Delegated to BU administrators

**Policy Files:**
- Stored in `policies/` directory
- Version controlled
- Applied via Terraform `vault_policy` resources

## Data Flows

### Workspace Provisioning Flow

```
1. Developer defines new workspace in namespace-vending/tn{XXX}.tf
      │
      ▼
2. Terraform apply creates:
      ├── HCP Terraform workspace resource
      ├── HCP Vault JWT auth role (bound to workspace)
      └── HCP Vault policy granting workspace access
      │
      ▼
3. HCP Terraform workspace can now authenticate to HCP Vault
      │
      ▼
4. Workspace runs use HCP Vault for secret retrieval
```

### Namespace Creation Flow

```
1. Define namespace in namespace-vending/tn{XXX}.tf
      │
      ▼
2. Module creates:
      ├── HCP Vault namespace
      ├── Namespace quota limits
      ├── Identity groups (admin, readers, contributors)
      └── Namespace-specific policies
      │
      ▼
3. Workspace module associates HCP Terraform workspace with namespace
      │
      ▼
4. Tenant namespace config (namespace-tn{XXX}/) can now:
      ├── Mount KV engines
      ├── Define custom policies
      └── Manage secrets within namespace
```

### Secret Access Pattern

```
Application → HCP Terraform Workspace → HCP Vault (JWT) → Namespace KV Store → Secret
      │              │                    │              │
      │              │                    │              └─ Path: kv/data/app/config
      │              │                    └─ Policy: tn001-kv-read
      │              └─ JWT Auth Role: tfc-tn001-workspace
      └─ Triggered by: terraform apply
```

## Security Considerations

### Namespace Isolation

- Each tenant has a dedicated namespace
- Policies are scoped to namespace paths
- Cross-namespace access requires explicit policy grants
- Root namespace access restricted to platform administrators

### Token Security

**HCP Terraform Workspace Tokens:**
- Short TTL (10-30 minutes default)
- Bound to specific workspace claims
- Cannot be used outside HCP Terraform runs
- Automatically renewed during runs

**Okta User Tokens:**
- TTL configurable (default 30 minutes)
- Renewable up to max TTL (default 1 hour)
- Revoked on Okta session termination
- MFA enforced at Okta layer

### Secret Management

- Secrets stored in KV v2 (versioned)
- Secret versions retained (configurable limit)
- Audit logging enabled for all secret access
- Deletion protection via KV v2 soft delete

### Least Privilege Access

- Policies grant minimum required permissions
- Read/write policies separated
- Namespace admin cannot access other namespaces
- HCP Terraform workspaces scoped to specific secret paths

### Audit & Compliance

- HCP Vault audit logs all API requests
- HCP Terraform maintains run logs
- Identity-based access tracking via Okta
- Policy changes version controlled in Git

## Deployment Workflow

### Initial Deployment Sequence

```
Step 1: Bootstrap
    ├── Apply: bootstrap/
    ├── Creates: JWT auth, HCP Terraform workspaces, Okta app
    └── Outputs: Auth paths, workspace IDs
         │
         ▼
Step 2: Namespace Root
    ├── Apply: namespace-root/
    ├── Creates: OIDC auth, identity groups
    └── Depends on: Bootstrap JWT auth backend
         │
         ▼
Step 3: Namespace Vending
    ├── Apply: namespace-vending/
    ├── Creates: BU namespaces, BU workspaces
    └── Depends on: Root namespace configuration
         │
         ▼
Step 4: Tenant Namespaces (parallel)
    ├── Apply: namespace-tn001/
    ├── Apply: namespace-tn002/
    ├── Apply: namespace-tn003/
    └── Depends on: Namespace vending completion
```

### State Dependencies

- **Bootstrap → Namespace Root:** JWT auth backend must exist
- **Namespace Root → Namespace Vending:** OIDC configuration must be complete
- **Namespace Vending → BU Namespaces:** Namespaces must be created
- **All components → HCP Terraform:** Remote state stored in HCP Terraform backend

### Rollback Procedures

**Rollback Strategy:**
1. Identify last known good state
2. Revert to previous Terraform code version
3. Run `terraform plan` to preview rollback
4. Apply changes in reverse dependency order (BU → Vending → Root → Bootstrap)

**Disaster Recovery:**
- HCP Terraform maintains state backups automatically
- HCP Vault data backed up separately (not managed by Terraform)
- Okta configuration external to this solution
- Re-apply bootstrap to recreate JWT auth

## CI/CD & Local Development

### Automated Validation

The project employs a GitHub Actions workflow for continuous integration, focusing on code quality and infrastructure validation:

- **Linting**: `tflint` is used recursively to identify provider-specific issues and best practice violations.
- **Formatting**: `terraform fmt -check` ensures all configurations adhere to standard HCL formatting.
- **Validation**: Every root configuration (`bootstrap/` and `namespace-*/`) undergoes `terraform validate` during the CI process.

### Local Development Workflow

To ensure high-quality contributions and minimize CI failures, developers can utilize the following tools:

1. **Local CI (act)**: The `task test-ci` command uses `act` to run the full GitHub Actions suite in a local Docker container, providing immediate feedback on changes.
2. **Task Automation**: `Taskfile.yml` provides simplified commands for common operations:
   - `task lint`: Runs pre-commit hooks.
   - `task validate`: Initializes and validates all Terraform directories.
   - `task init`: Upgrades and initializes all Terraform directories without a backend.

## Design Decisions

### Why HCP Terraform for State Management

**Decision:** Use HCP Terraform as remote backend for all configurations

**Rationale:**
- Centralized state management
- Built-in state locking
- Audit trail for all state changes
- Secure variable storage
- Workspace-based isolation
- Native HCP Vault integration

**Alternatives Considered:**
- S3 backend: Requires additional locking infrastructure (DynamoDB)
- Local state: Not suitable for team collaboration
- Git-based state: Security risk, no locking

### Namespace-Based Multi-Tenancy

**Decision:** Use HCP Vault namespaces to isolate tenants

**Rationale:**
- Strong isolation boundaries
- Independent policy management
- Quota enforcement per namespace
- Simplified access control
- Native HCP Vault feature (Enterprise)

**Alternatives Considered:**
- Path-based isolation: Weaker boundaries, complex policies
- Separate HCP Vault clusters: Higher operational overhead
- Shared namespace with strict policies: Risk of policy errors

### Module Decomposition

**Decision:** Three reusable modules (namespace, workspace, kv-engine)

**Rationale:**
- Single responsibility per module
- Reusable across tenants
- Clear abstraction boundaries
- Easier testing and validation

**Module Design:**
- **namespace:** Creates HCP Vault namespace with RBAC
- **workspace:** Creates HCP Terraform workspace with HCP Vault auth
- **kv-engine:** Mounts KV secrets engine

### GitHub App Integration

**Decision:** Use GitHub App for VCS integration with HCP Terraform

**Rationale:**
- Fine-grained repository access
- Better security than personal access tokens
- Organization-level installation
- Automatic webhook management

**Implementation:**
- GitHub App data source in workspace module
- VCS repo block configures branch and identifier
- Trigger patterns define what changes invoke runs

## Scalability & Maintenance

### Adding New Tenants

**Process:**
1. Create `namespace-vending/tn{XXX}.tf`
2. Define namespace using namespace module
3. Define workspace using workspace module
4. Apply namespace-vending configuration
5. Create `namespace-tn{XXX}/` directory
6. Add backend, providers, variables, main configurations
7. Apply tenant configuration

**Estimated Time:** 15-20 minutes per BU

### Module Versioning Strategy

**Current Approach:** Local path-based modules

**Considerations for Future:**
- Git-based module sources with version tags
- Private Terraform registry for module hosting
- Semantic versioning for breaking changes
- Module changelog documentation

### Policy Lifecycle Management

**Policy Updates:**
1. Modify policy HCL in `policies/` directory
2. Update Terraform resource referencing policy
3. Run `terraform plan` to preview changes
4. Apply changes to update HCP Vault policy

**Policy Testing:**
- Use `vault policy fmt` to validate syntax
- Test policies in non-production namespace first
- Document policy changes in Git commit messages

### Monitoring & Observability

**Recommended Integrations:**
- HCP Vault audit logs → SIEM (Splunk, ELK)
- HCP Terraform run notifications → Slack/PagerDuty
- HCP Vault telemetry → Prometheus/Grafana
- Okta event hooks → Security monitoring

**Key Metrics:**
- HCP Vault token creation rate
- Failed authentication attempts
- HCP Terraform workspace run success rate
- Namespace quota utilization

## Future Enhancements

### Potential Improvements

1. **Dynamic Secret Engines**
   - Add database secret engine modules
   - AWS/Azure dynamic credential generation
   - SSH certificate authority

2. **Advanced RBAC**
   - Entity aliases for service accounts
   - Group-based policy inheritance
   - Time-based access controls

3. **Multi-Region Support**
   - HCP Vault replication configuration
   - Region-aware workspace provisioning
   - Disaster recovery automation

4. **Enhanced Observability**
   - Custom HCP Vault metrics exporters
   - HCP Terraform run analytics dashboards
   - Policy compliance reporting

5. **Self-Service Portal**
   - Web UI for namespace requests
   - Automated approval workflows
   - Secret lifecycle management

## References

- [HCP Vault Enterprise Namespaces](https://developer.hashicorp.com/vault/docs/enterprise/namespaces)
- [HCP Terraform Workload Identity](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/vault-configuration)
- [HCP Vault JWT/OIDC Auth](https://developer.hashicorp.com/vault/docs/auth/jwt)
- [Okta OIDC Integration](https://developer.okta.com/docs/guides/implement-oauth-for-okta/main/)
