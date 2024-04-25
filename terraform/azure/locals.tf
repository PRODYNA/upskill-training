locals {
  location  = "germanywestcentral"
  loc_short = "gwc"
  tags = {
    env     = var.environment
    project = var.project_name
  }
  resource_prefix = "${local.tags.project}-${local.loc_short}-${local.tags.env}"
  image = {
    repository = "sample"
    tag        = "1.1"
  }
}