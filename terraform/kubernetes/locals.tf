locals {
  location  = "westeurope"
  loc_short = "weu"
  tags = {
    env     = data.terraform_remote_state.azure.outputs.environment
    project = data.terraform_remote_state.azure.outputs.project_name
  }
  resource_prefix = "${local.tags.project}-${local.loc_short}-${local.tags.env}"
}