resource "azurerm_resource_group" "main" {
  name     = var.project_name
  location = local.location
  tags = {
    managed_by = "terraform"
  }
}
