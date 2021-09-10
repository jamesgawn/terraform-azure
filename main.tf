terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.76.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "gawnbackend"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }

}