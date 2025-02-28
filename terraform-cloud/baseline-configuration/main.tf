resource "vault_quota_rate_limit" "global" {
  name     = "global"
  path     = ""
  interval = 30
  rate     = 300000
}

# resource "vault_audit" "file" {
#   options = {
#     file_path = "/var/logs/vault_audit.log"
#   }
#   type = "file"
# }