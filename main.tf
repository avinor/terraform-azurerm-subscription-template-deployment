terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.93.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_subscription_template_deployment" "main" {
  name               = var.name
  location           = var.location
  parameters_content = var.parameters_content
  template_content   = var.template_content
  tags               = var.tags
}
