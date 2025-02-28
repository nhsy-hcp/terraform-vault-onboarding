#data "vault_policy_document" "tfc_namespace" {
#  # Create and manage namespace ACL policies
#  rule {
#    path         = "+/sys/policies/acl/*"
#    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
#  }
#  # List namespace ACL policies
#  rule {
#    path         = "+/sys/policies/acl"
#    capabilities = ["list"]
#  }
#  #  # Create and manage namespace group identities
#  #  rule {
#  #    path         = "+/identity/*"
#  #    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
#  #  }
#  #  # List namespace identities
#  #  rule {
#  #    path         = "+/identity"
#  #    capabilities = ["list"]
#  #  }
#  rule {
#    path         = "+/auth/token/*"
#    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
#  }
#}

#resource "vault_policy" "tfc_namespace" {
#  name   = "tfc-namespace"
#  policy = data.vault_policy_document.tfc_namespace.hcl
#}