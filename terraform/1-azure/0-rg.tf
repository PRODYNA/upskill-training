/*
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.environment}"
  location = var.location
  tags     = local.tags
}
*/

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}
