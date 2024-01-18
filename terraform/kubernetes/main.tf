###############
## TERRAFORM ##
###############

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.87.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.25.2"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }
  }
}

##############
## PROVIDER ##
##############

provider "azurerm" {
  features {}
  subscription_id = "cd4b198a-f112-461a-a3c3-d3d33c059e5c"
}

# setting up the connection to the AKS cluster
provider "kubernetes" {
    host                   = data.azurerm_kubernetes_cluster.aks.kube_admin_config[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_admin_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_admin_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_admin_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.aks.kube_admin_config[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_admin_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_admin_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_admin_config[0].cluster_ca_certificate)
  }
}

##################
## DATA SOURCES ##
##################

data "azurerm_client_config" "current" {}

data "terraform_remote_state" "azure" {
  backend = "local"

  config = {
    path = "../azure/terraform.tfstate"
  }
}

data "azurerm_resource_group" "main" {
  name = data.terraform_remote_state.azure.outputs.resource_group_name
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = "${local.resource_prefix}-aks-main"
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_public_ip" "ingress" {
  name                = "${local.resource_prefix}-pip-ingress"
  resource_group_name = data.azurerm_resource_group.main.name
}
