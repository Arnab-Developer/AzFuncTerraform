terraform {
  required_version = "1.11.1"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.23.0"
    }
  }

  backend "local" {
    path = "terraapp1.tfstate"
  }
}

provider "azurerm" {
  features {}
}

locals {
  application = "terraapp1"
  environment = "dev"

  dashed_name    = "${local.application}-${local.environment}"
  continous_name = "${local.application}${local.environment}"
}

resource "azurerm_resource_group" "test" {
  name     = "rg-${local.dashed_name}"
  location = "North Europe"
}

resource "azurerm_linux_function_app" "test" {
  name                       = "func-${local.dashed_name}"
  service_plan_id            = azurerm_service_plan.test.id
  storage_account_name       = azurerm_storage_account.test.name
  storage_account_access_key = azurerm_storage_account.test.primary_access_key
  resource_group_name        = azurerm_resource_group.test.name
  location                   = azurerm_resource_group.test.location

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
  }

  app_settings = {
    "FUNCTIONS_INPROC_NET8_ENABLED" = "1"
  }
}

resource "azurerm_service_plan" "test" {
  name                = "plan-${local.dashed_name}"
  os_type             = "Linux"
  sku_name            = "Y1"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
}

resource "azurerm_storage_account" "test" {
  name                     = "st${local.continous_name}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location
}
