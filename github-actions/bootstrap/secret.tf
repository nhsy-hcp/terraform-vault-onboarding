#resource "vault_mount" "kv" {
#  path        = "secret"
#  type        = "kv"
#  options     = { version = "2" }
#  description = "KV Version 2 secret engine mount"
#}
#
#resource "vault_kv_secret_v2" "example" {
#  mount               = vault_mount.kv.path
#  name                = "example"
#  cas                 = 1
#  delete_all_versions = true
#  data_json = jsonencode(
#    {
#      zip = "zap",
#      foo = "bar"
#    }
#  )
#}
