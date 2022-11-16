include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${dirname(find_in_parent_folders())}//modules/lambda_with_hook"

  before_hook "package_layer_cmd1" {
    commands = ["plan", "apply"]
    execute  = ["pip", "install", "-r", "requirements.txt", "-t", "python"]
  }

  before_hook "package_layer_cmd2" {
    commands = ["plan", "apply"]
    execute  = ["zip", "-r", "layer.zip", "python"]
  }

  before_hook "package_source" {
    commands = ["plan", "apply"]
    execute  = ["zip", "package.zip", "main.py"]
  }
}

locals {
  env_vars = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
}

inputs = {
  env = local.env_vars.env
}