# Solution Design: HCP Terraform & Vault Integration

## Overview

This solution provides automated provisioning and management of HashiCorp Vault infrastructure integrated with HCP Terraform (HCP Terraform). It implements a multi-tenant namespace architecture that enables isolated secret management for multiple business units while maintaining centralized administration and consistent security policies.

### Key Capabilities

- Automated Vault namespace provisioning for business units
- HCP Terraform workspace creation with Vault authentication
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
│  │  Workspace   │  │  Vending     │  │  (bu01)      │          │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │
│         │                  │                  │                │
│         │ JWT Auth         │ JWT Auth         │ JWT Auth       │
└─────────┼──────────────────┼──────────────────┼────────────────┘
          │                  │                  │
          ▼                  ▼                  ▼
┌────────────────────────────────────────────────────────────────┐
│                      HashiCorp Vault                           │
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
│  │   bu01       │          │   bu02       │  │   bu03       │  │
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
    ├── Creates Child Namespaces (bu01, bu02, bu03)
    ├── Provisions HCP Terraform Workspaces per BU
    └── Configures Namespace-Specific Policies
        │
        ▼
Business Unit Namespaces (bu01, bu02, bu03)
    │
    └── Custom Resources per BU (KV engines, additional policies)
```

## Core Components

### 1. Bootstrap Module

**Purpose:** Initialize foundational infrastructure

**Location:** `bootstrap/`

**Key Resources:**
- Vault JWT authentication backend for HCP Terraform
- Okta OAuth application and authorization server
- HCP Terraform workspaces for `namespace-root` and `namespace-vending`
- Admin policies for HCP Terraform workspaces

**Responsibilities:**
- Configure Vault-HCP Terraform authentication
- Set up Okta integration
- Create initial HCP Terraform workspaces
- Establish admin access patterns

### 2. Namespace Root

**Purpose:** Configure root Vault namespace

**Location:** `namespace-root/`

**Key Resources:**
- OIDC authentication method (Okta)
- Root-level identity groups
- Okta user and group mappings

**Responsibilities:**
- Enable human access to Vault via Okta
- Configure identity-based access control
- Establish root namespace policies

### 3. Namespace Vending

**Purpose:** Automated business unit namespace provisioning

**Location:** `namespace-vending/`

**Key Resources:**
- Child Vault namespaces (one per BU)
- HCP Terraform workspaces for each BU namespace
- Namespace-specific policies
- RBAC delegation configurations

**Responsibilities:**
- Create isolated namespaces per business unit
- Provision HCP Terraform workspaces with Vault integration
- Configure namespace-level policies
- Set up delegated administration

### 4. Business Unit Namespaces

**Purpose:** Per-BU customization and resource management

**Location:** `namespace-bu01/`, `namespace-bu02/`, `namespace-bu03/`

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
- `quota_lease_count` - Lease count quota
- `quota_rate_limit` - Rate limit quota
- `rbac_delegation` - Map of RBAC delegations

**Outputs:**
- `namespace` - Created namespace name

**Purpose:** Creates a Vault namespace with quotas, identity groups, and policies

### workspace Module

**Location:** `modules/workspace/`

**Inputs:**
- `tfc_workspace` - Workspace name
- `tfc_project` - HCP Terraform project name
- `tfc_organization` - HCP Terraform org name
- `tfc_working_directory` - Working directory in repo
- `vault_address` - Vault server URL
- `vault_auth_path` - JWT auth mount path
- `vault_auth_role` - Role name for workspace
- `vault_namespace` - Target Vault namespace (optional)
- `github_organization` - GitHub org name
- `github_repository` - GitHub repo name

**Outputs:**
- `workspace_id` - HCP Terraform workspace ID

**Purpose:** Creates a HCP Terraform workspace with Vault authentication configured via JWT

### kv-engine Module

**Location:** `modules/kv-engine/`

**Inputs:**
- `path` - Mount path for KV engine
- `namespace` - Target Vault namespace
- `max_versions` - Maximum secret versions to retain

**Purpose:** Manages KV v2 secrets engine mounts

## Authentication & Authorization

### HCP Terraform to Vault (JWT)

**Flow:**

```
┌─────────────────────────┐
│ HCP Terraform Workspace │
│ (Terraform Run)         │
└────────┬────────────────┘
         │ 1. Request Vault token
         │    (with JWT from HCP Terraform)
         ▼
┌─────────────────────────┐
│ Vault JWT Auth Backend  │
│ - Validates JWT         │
│ - Checks bound claims   │
│ - Issues Vault token    │
└────────┬────────────────┘
         │ 2. Vault token
         │    (scoped to policies)
         ▼
┌──────────────────────────┐
│ HCP Terraform Workspace  │
│ Uses token to            │
│ manage Vault             │
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
   - `HCP Terraform_VAULT_PROVIDER_AUTH=true`
   - `HCP Terraform_VAULT_ADDR` - Vault server address
   - `HCP Terraform_VAULT_NAMESPACE` - Target namespace (if applicable)
   - `HCP Terraform_VAULT_RUN_ROLE` - Role name for authentication
   - `HCP Terraform_VAULT_AUTH_PATH` - JWT backend mount path

**Security:**
- Tokens are short-lived (configurable TTL)
- Bound claims ensure only specific workspaces can assume roles
- Policies grant least-privilege access
- No static credentials stored in HCP Terraform

### Okta to Vault (OIDC)

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
┌─────────────────────────┐
│ Vault OIDC Auth Backend │
│ - Validate token        │
│ - Map groups            │
│ - Issue Vault token     │
└──────┬──────────────────┘
       │ 3. Vault token
       │    (with group policies)
       ▼
┌─────────────┐
│   User      │
│ Access Vault│
└─────────────┘
```

**Configuration:**

1. **Okta OAuth Application** (configured in `bootstrap/okta.tf`):
   - Authorization server with custom claims
   - Groups claim: `groups`
   - Application type: Web
   - Redirect URIs: Vault callback URLs

2. **Vault OIDC Auth** (configured in `namespace-root/vault.tf`):
   - OIDC discovery URL: Okta authorization server
   - Bound audiences: Okta client ID
   - Group claims: `groups`

3. **Identity Groups** (mapped to Okta groups):
   - `vault-admin` - Full administrative access
   - `vault-user` - Read-only access
   - BU-specific groups (e.g., `vault-bu01-admin`)

**Security:**
- OIDC tokens are validated cryptographically
- Group membership determines policy assignment
- MFA enforced via Okta policies
- Session duration controlled by Vault token TTL

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

### Example Policy Structure

```hcl
# HCP Terraform Admin Policy
path "sys/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
```

```hcl
# Namespace-Scoped Policy
path "kv/data/bu01/*" {
  capabilities = ["read", "list"]
}

path "kv/metadata/bu01/*" {
  capabilities = ["list"]
}
```

## Data Flows

### Workspace Provisioning Flow

```
1. Developer defines new workspace in namespace-vending/bu{XX}.tf
      │
      ▼
2. Terraform apply creates:
      ├── HCP Terraform workspace resource
      ├── Vault JWT auth role (bound to workspace)
      └── Vault policy granting workspace access
      │
      ▼
3. HCP Terraform workspace can now authenticate to Vault
      │
      ▼
4. Workspace runs use Vault for secret retrieval
```

### Namespace Creation Flow

```
1. Define namespace in namespace-vending/bu{XX}.tf
      │
      ▼
2. Module creates:
      ├── Vault namespace
      ├── Namespace quota limits
      ├── Identity groups (admin, readers, contributors)
      └── Namespace-specific policies
      │
      ▼
3. Workspace module associates HCP Terraform workspace with namespace
      │
      ▼
4. Business unit namespace config (namespace-bu{XX}/) can now:
      ├── Mount KV engines
      ├── Define custom policies
      └── Manage secrets within namespace
```

### Secret Access Pattern

```
Application → HCP Terraform Workspace → Vault (JWT) → Namespace KV Store → Secret
      │              │              │              │
      │              │              │              └─ Path: kv/data/app/config
      │              │              └─ Policy: bu01-kv-read
      │              └─ JWT Auth Role: tfc-bu01-workspace
      └─ Triggered by: terraform apply
```

## Security Considerations

### Namespace Isolation

- Each business unit has a dedicated namespace
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

- Vault audit logs all API requests
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
Step 4: Business Unit Namespaces (parallel)
    ├── Apply: namespace-bu01/
    ├── Apply: namespace-bu02/
    ├── Apply: namespace-bu03/
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
- Vault data backed up separately (not managed by Terraform)
- Okta configuration external to this solution
- Re-apply bootstrap to recreate JWT auth

## Design Decisions

### Why HCP Terraform for State Management

**Decision:** Use HCP Terraform as remote backend for all configurations

**Rationale:**
- Centralized state management
- Built-in state locking
- Audit trail for all state changes
- Secure variable storage
- Workspace-based isolation
- Native Vault integration

**Alternatives Considered:**
- S3 backend: Requires additional locking infrastructure (DynamoDB)
- Local state: Not suitable for team collaboration
- Git-based state: Security risk, no locking

### Namespace-Based Multi-Tenancy

**Decision:** Use Vault namespaces to isolate business units

**Rationale:**
- Strong isolation boundaries
- Independent policy management
- Quota enforcement per namespace
- Simplified access control
- Native Vault feature (Enterprise)

**Alternatives Considered:**
- Path-based isolation: Weaker boundaries, complex policies
- Separate Vault clusters: Higher operational overhead
- Shared namespace with strict policies: Risk of policy errors

### Module Decomposition

**Decision:** Three reusable modules (namespace, workspace, kv-engine)

**Rationale:**
- Single responsibility per module
- Reusable across business units
- Clear abstraction boundaries
- Easier testing and validation

**Module Design:**
- **namespace:** Creates Vault namespace with RBAC
- **workspace:** Creates HCP Terraform workspace with Vault auth
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

### Adding New Business Units

**Process:**
1. Create `namespace-vending/bu{XX}.tf`
2. Define namespace using namespace module
3. Define workspace using workspace module
4. Apply namespace-vending configuration
5. Create `namespace-bu{XX}/` directory
6. Add backend, providers, variables, main configurations
7. Apply business unit configuration

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
4. Apply changes to update Vault policy

**Policy Testing:**
- Use `vault policy fmt` to validate syntax
- Test policies in non-production namespace first
- Document policy changes in Git commit messages

### Monitoring & Observability

**Recommended Integrations:**
- Vault audit logs → SIEM (Splunk, ELK)
- HCP Terraform run notifications → Slack/PagerDuty
- Vault telemetry → Prometheus/Grafana
- Okta event hooks → Security monitoring

**Key Metrics:**
- Vault token creation rate
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
   - Vault replication configuration
   - Region-aware workspace provisioning
   - Disaster recovery automation

4. **Enhanced Observability**
   - Custom Vault metrics exporters
   - HCP Terraform run analytics dashboards
   - Policy compliance reporting

5. **Self-Service Portal**
   - Web UI for namespace requests
   - Automated approval workflows
   - Secret lifecycle management

## References

- [Vault Enterprise Namespaces](https://developer.hashicorp.com/vault/docs/enterprise/namespaces)
- [HCP Terraform Workload Identity](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/vault-configuration)
- [Vault JWT/OIDC Auth](https://developer.hashicorp.com/vault/docs/auth/jwt)
- [Okta OIDC Integration](https://developer.okta.com/docs/guides/implement-oauth-for-okta/main/)
