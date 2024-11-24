# #################
# ## INGRESS PIP ##
# #################

resource "azurerm_public_ip" "ingress" {
  allocation_method    = "Static"
  name                 = "${local.resource_prefix}-ip-ingress"
  sku                  = "Standard"
  location             = var.location
  resource_group_name  = data.azurerm_resource_group.main.name
  tags                 = local.tags
  zones                = [1, 2, 3]
  ddos_protection_mode = var.enable_ddos_protection == true ? "Enabled" : "Disabled"

  lifecycle {
    ignore_changes = [
      tags["service"],
      tags["k8s-azure-service"]
    ]
  }
}

resource "azurerm_public_ip" "istio" {
  allocation_method    = "Static"
  name                 = "${local.resource_prefix}-ip-istio"
  sku                  = "Standard"
  location             = var.location
  resource_group_name  = data.azurerm_resource_group.main.name
  tags                 = local.tags
  zones                = [1, 2, 3]
  ddos_protection_mode = var.enable_ddos_protection == true ? "Enabled" : "Disabled"

  lifecycle {
    ignore_changes = [
      tags["service"],
      tags["k8s-azure-service"]
    ]
  }
}

resource "azurerm_virtual_network" "azurecilium" {
  name                = "${local.resource_prefix}-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = local.tags
}

resource "azurerm_subnet" "azureciliumnodes" {
  name                 = "azurecilium-subnet-nodes"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.azurecilium.name
  address_prefixes     = ["10.240.0.0/16"]
}

resource "azurerm_subnet" "azureciliumpods" {
  name                 = "azurecilium-subnet-pods"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.azurecilium.name
  address_prefixes     = ["10.241.0.0/16"]
  delegation {
    name = "aks-delegation"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
      name = "Microsoft.ContainerService/managedClusters"
    }
  }
}
