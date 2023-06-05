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

# Use ENV vars 
variable "STORAGE_ACCOUNT_NAME" {
  type = string
}

variable "TENANT_ID" {
  type = string
}

variable "SECRET_SCOPE_NAME" {
  type = string
}

# Create the cluster with the "smallest" amount
# of resources allowed.
data "databricks_node_type" "smallest" {
  local_disk = true
}

# Use the latest Databricks Runtime
# Long Term Support (LTS) version.
data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

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
  depends_on = [
    databricks_git_credential.git
  ]
}

# Configure Test Cluster
resource "databricks_cluster" "cluster" {
  cluster_name            = "test-cluster"
  node_type_id            = data.databricks_node_type.smallest.id
  spark_version           = data.databricks_spark_version.latest_lts.id
  autotermination_minutes = 10
  num_workers = 1
  spark_conf = {
    format("fs.azure.account.auth.type.%s.dfs.core.windows.net", var.STORAGE_ACCOUNT_NAME) = "OAuth"
    format("fs.azure.account.oauth.provider.type.%s.dfs.core.windows.net", var.STORAGE_ACCOUNT_NAME) = "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider"
    format("fs.azure.account.oauth2.client.id.%s.dfs.core.windows.net", var.STORAGE_ACCOUNT_NAME) = format("{{secrets/%s/sp-databricks-poc-app-id}}", var.SECRET_SCOPE_NAME)
    format("fs.azure.account.oauth2.client.secret.%s.dfs.core.windows.net", var.STORAGE_ACCOUNT_NAME) = format("{{secrets/%s/sp-databricks-poc-app-secret}}", var.SECRET_SCOPE_NAME)
    format("fs.azure.account.oauth2.client.endpoint.%s.dfs.core.windows.net", var.STORAGE_ACCOUNT_NAME) = format("https://login.microsoftonline.com/%s/oauth2/token", var.TENANT_ID)
  }
}

