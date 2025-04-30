###############
## TERRAFORM ##
###############

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.27.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.0"
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

provider "time" {}

##################
## DATA SOURCES ##
##################

data "azurerm_client_config" "current" {}
