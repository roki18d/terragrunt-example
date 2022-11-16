include "root" {
  path = find_in_parent_folders()
}

locals {
  env_vars = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
  source   = "${dirname(find_in_parent_folders())}//modules/lambda_with_hook"
}


terraform {
  source = local.source

  before_hook "mkdir" {
    commands    = ["apply"]
    working_dir = "${local.source}/src"
    execute     = ["mkdir", "-p", "python"]
  }

  before_hook "package_layer_cmd2" {
    commands    = ["apply"]
    working_dir = "${local.source}/src"
    execute     = ["pip", "install", "-r", "requirements.txt", "-t", "python"]
  }

  before_hook "package_layer_cmd3" {
    commands    = ["apply"]
    working_dir = "${local.source}/src"
    execute     = ["zip", "-r", "layer.zip", "python"]
  }

  before_hook "package_source" {
    commands    = ["plan", "apply"]
    working_dir = "${local.source}/src"
    execute     = ["zip", "package.zip", "main.py"]
  }
}

inputs = {
  env = local.env_vars.env
}
