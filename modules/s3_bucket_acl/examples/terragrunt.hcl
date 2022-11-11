include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${dirname(find_in_parent_folders())}//modules/s3_bucket_acl"
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  env_vars    = yamldecode(file(find_in_parent_folders("env_vars.yaml")))

  org = local.common_vars.org
  env = local.env_vars.env
}

inputs = {
  bucket_name = "${local.org}-example-bucket-${local.env}"
}
