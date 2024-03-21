provider "okta" {
  org_name = split("//", var.okta_org_url)[1]
}

provider "vault" {
  #  skip_child_token = true
}
