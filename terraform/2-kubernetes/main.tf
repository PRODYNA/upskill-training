###############
## TERRAFORM ##
###############

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.8.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.33.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}

##############
## PROVIDER ##
##############

provider "azurerm" {
  features {}
  subscription_id = data.terraform_remote_state.azure.outputs.subscription_id
}

# setting up the connection to the AKS cluster
provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.main.kube_admin_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.main.kube_admin_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.main.kube_admin_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.main.kube_admin_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.main.kube_admin_config[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.main.kube_admin_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.main.kube_admin_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.main.kube_admin_config[0].cluster_ca_certificate)
  }
}

##################
## DATA SOURCES ##
##################

data "azurerm_client_config" "current" {}

data "terraform_remote_state" "azure" {
  backend = "local"

  config = {
    path = "../1-azure/terraform.tfstate"
  }
}

data "azurerm_resource_group" "main" {
  name = data.terraform_remote_state.azure.outputs.resource_group_name
}

data "azurerm_kubernetes_cluster" "main" {
  name                = data.terraform_remote_state.azure.outputs.kubernetes_cluster.name
  resource_group_name = data.terraform_remote_state.azure.outputs.resource_group_name
}

data "azurerm_public_ip" "traefik" {
  name                = data.terraform_remote_state.azure.outputs.traefik_ip.name
  resource_group_name = data.terraform_remote_state.azure.outputs.resource_group_name
}

data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = data.terraform_remote_state.azure.outputs.log_analytics_workspace.name
  resource_group_name = data.terraform_remote_state.azure.outputs.resource_group_name
}

data "azurerm_application_insights" "application_insights" {
  name                = data.terraform_remote_state.azure.outputs.application_insights.name
  resource_group_name = data.terraform_remote_state.azure.outputs.resource_group_name
}