###############
## TERRAFORM ##
###############

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.98.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "4.29.0"
    }
  }
}

##############
## PROVIDER ##
##############

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  // skip_provider_registration = true
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

##################
## DATA SOURCES ##
##################

data "azurerm_client_config" "current" {}
