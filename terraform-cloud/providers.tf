provider "okta" {
  org_name = split("//", var.okta_org_url)[1]
  # api_token = var.okta_api_token
}

provider "vault" {
  #  skip_child_token = true
}
