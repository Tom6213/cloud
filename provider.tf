terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.89.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  client_id       = "ee87a6a9-5138-40bc-ac31-2251aed4f098"
  client_secret   = "E7E8Q~UOzEE5tK6yVM7GGagvEPGp8pI54-gCWbt0"
  tenant_id       = "246508ce-3c22-40c9-bc9e-0f02a1355a02"
  subscription_id = "8ff3f63e-3474-4b06-ab5d-0c3273c698d9"
}