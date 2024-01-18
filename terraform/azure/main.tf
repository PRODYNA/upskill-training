###############
## TERRAFORM ##
###############

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.87.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "4.22.0"
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

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

##################
## DATA SOURCES ##
##################

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}