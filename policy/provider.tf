# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 3.76.0"
#     }
#   }
# }
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.92.0"
    }
  }
}

provider "azurerm" {
  features {}
}