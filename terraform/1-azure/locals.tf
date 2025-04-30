locals {
  tags = {
    project    = var.project_name
    managed_by = "terraform"
  }
  resource_prefix = local.tags.project
  image = {
    repository = "sample"
    tag        = "1.1"
  }
}
