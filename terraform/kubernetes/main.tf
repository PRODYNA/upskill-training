###############
## TERRAFORM ##
###############

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.98.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.27.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.13.0"
    }
  }
}

##############
## PROVIDER ##
##############

provider "azurerm" {
  features {}
  subscription_id = "5383c002-d638-4986-a0e9-74decda8b3f4"
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
