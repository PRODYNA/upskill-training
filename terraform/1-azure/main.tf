###############
## TERRAFORM ##
###############

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.8.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.45.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.12.1"
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
