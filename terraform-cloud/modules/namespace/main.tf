locals {
  rbac_policies = flatten([
    for delegation_key, delegation in var.rbac_delegation : [
      for policy_key, policy_hcl in delegation.policies : {
        name   = "${delegation_key}-${policy_key}"
        policy = policy_hcl
      }
    ]
  ])
}
