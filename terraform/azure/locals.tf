locals {
  location  = "westeurope"
  loc_short = "weu"
  tags = {
    env     = var.environment
    project = var.project_name
  }
  resource_prefix = "${local.tags.project}-${local.loc_short}-${local.tags.env}"
  image = {
    repository = "sample"
    tag        = "1.0"
  }
}