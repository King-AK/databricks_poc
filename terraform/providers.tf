terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.75.0"
    }
    databricks = {
      source = "databricks/databricks"
      version = "1.115.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

provider "databricks" {
  azure_workspace_resource_id = module.azure-databricks-workspace.databricks_workspace_resource_id
  host = module.azure-databricks-workspace.databricks_workspace_url
  auth_type = "azure-cli"
}

provider "databricks" {
  alias      = "azure_account"
  host       = "https://accounts.azuredatabricks.net"
  account_id = "00000000-0000-0000-0000-000000000000"
  auth_type  = "azure-cli"
}
