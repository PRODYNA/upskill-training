resource "azurerm_resource_group" "main" {
  name     = var.project_name
  location = var.location
  tags     = local.tags
}
