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

dependency "s3_bucket" {
  config_path = "${dirname(find_in_parent_folders())}/envs/dev/s3_bucket"

  mock_outputs = {
    bucket_name = "hoge"
  }
}

inputs = {
  bucket_name = dependency.s3_bucket.outputs.bucket_name
}
