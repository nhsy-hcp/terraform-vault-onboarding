provider "okta" {
  api_token = var.okta_api_token
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
}
