locals {
  tags = {
    project    = var.project_name
    env        = var.environment
    managed_by = "terraform"
  }
  resource_prefix = "${local.tags.project}-${local.tags.env}"
  image = {
    repository = "sample"
    tag        = "1.1"
  }
}
