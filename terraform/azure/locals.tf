locals {
  location  = "germanywestcentral"
  tags = {
    env     = var.environment
    project = var.project_name
  }
  resource_prefix = "${local.tags.project}-${local.tags.env}"
  image = {
    repository = "sample"
    tag        = "1.1"
  }
}
