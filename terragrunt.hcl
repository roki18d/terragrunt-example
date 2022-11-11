remote_state {
  backend = "s3"
  config = {
    region  = "ap-northeast-1"
    bucket  = "terragrunt-example-tfstate"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    encrypt = true
  }
  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  env_vars    = yamldecode(file(find_in_parent_folders("env_vars.yaml")))

  account_id  = get_aws_account_id()
  region_name = local.common_vars.region_name
  org         = local.common_vars.org
  env         = local.env_vars.env
}

generate "provider" {
  path      = "_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    provider "aws" {
      region = "${local.region_name}"
      default_tags {
        tags = {
          Environment = "${local.env}"
        }
      }
    }
  EOF
}

generate "data" {
  path      = "_data.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file(find_in_parent_folders("data.tf"))
}

generate "terraform" {
  path      = "_terraform.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file(find_in_parent_folders("terraform.tf"))
}
