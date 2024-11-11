locals {
  location  = "germanywestcentral"
  loc_short = "gwc"
  tags = {
    env     = data.terraform_remote_state.azure.outputs.environment
    project = data.terraform_remote_state.azure.outputs.project_name
  }
  resource_prefix = "${local.tags.project}-${local.loc_short}-${local.tags.env}"
}