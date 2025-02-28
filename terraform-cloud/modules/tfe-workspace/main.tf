locals {
  short_name = split("/", var.tfc_working_directory)[1]
}