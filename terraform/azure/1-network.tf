#################
## INGRESS PIP ##
#################

resource "azurerm_public_ip" "ingress" {
  allocation_method   = "Static"
  name                = "${local.resource_prefix}-pip-ingress"
  sku                 = "Standard"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = local.tags
  zones               = [1,2,3]
  ddos_protection_mode = var.enable_ddos_protection == true ? "Enabled" : "Disabled"
  
  lifecycle {
    ignore_changes = [
      tags[ "service" ],
      tags[ "k8s-azure-service" ]
    ]
  }
}