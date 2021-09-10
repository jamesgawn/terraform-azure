terraform {
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "gawnbackend"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}