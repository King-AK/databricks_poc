# Terraform 
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    databricks = {
      source = "databricks/databricks"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Use environment variables for authentication.
provider "databricks" {}

# Configure Git Connection
resource "databricks_git_credential" "git" {
  git_username = "king-ak@github.com"
  git_provider = "gitHub"
  force        = true
}

# Configure Databricks Repo
resource "databricks_repo" "repo" {
  url          = "https://github.com/King-AK/databricks_repo_poc.git"
  git_provider = "gitHub"
}

