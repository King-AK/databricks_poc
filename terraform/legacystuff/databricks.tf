## Terraform
#terraform {
#  required_providers {
#    azurerm = {
#      source = "hashicorp/azurerm"
#    }
#    databricks = {
#      source = "databricks/databricks"
#    }
#  }
#}
#
#provider "azurerm" {
#  features {}
#}
#provider "databricks" {
#  config_file = "~/.databrickscfg"
#}
#
##### Variables
#variable "storage_account_name" {
#  type = string
#}
#
#variable "storage_account_container_name" {
#  type = string
#}
#
#variable "tenant_id" {
#  type = string
#}
#
#variable "keyvault_name" {
#  type = string
#}
#
#variable "git_username" {
#  type    = string
#  default = "king-ak@github.com"
#}
#
#variable "git_provider" {
#  type    = string
#  default = "gitHub"
#}
#
#variable "databricks_repo_url" {
#  type    = string
#  default = "https://github.com/King-AK/databricks_repo_poc.git"
#}
#
#variable "databricks_etl_cluster_name" {
#  type    = string
#  default = "test-cluster"
#}
#
#variable "keyvault_rg_name" {
#  type = string
#}
#
#### Data
## Create the cluster with the "smallest" amount of resources allowed.
#data "databricks_node_type" "smallest" {
#  local_disk = true
#}
#
## # Use the latest Databricks Runtime Long Term Support (LTS) version.
## data "databricks_spark_version" "latest_lts" {
##   long_term_support = true
## }
#
## Get Keyvault information
#data "azurerm_key_vault" "keyVault" {
#  name                = var.keyvault_name
#  resource_group_name = var.keyvault_rg_name
#}
#
#### Resources
## Configure Git Connection
#resource "databricks_git_credential" "git" {
#  git_username = var.git_username
#  git_provider = var.git_provider
#  force        = true
#}
#
## Configure Databricks Repo
#resource "databricks_repo" "repo" {
#  url          = var.databricks_repo_url
#  path         = "/Repos/databricks_poc/databricks_repo_poc"
#  git_provider = var.git_provider
#  depends_on = [
#    databricks_git_credential.git
#  ]
#}
#
## Configure Databricks Secret Scope
#resource "databricks_secret_scope" "akv_secret_scope" {
#  name                     = var.keyvault_name
#  initial_manage_principal = "users"
#
#  keyvault_metadata {
#    resource_id = data.azurerm_key_vault.keyVault.id
#    dns_name    = data.azurerm_key_vault.keyVault.vault_uri
#  }
#}
#
## Configure ETL Cluster
#resource "databricks_cluster" "etl_cluster" {
#  cluster_name            = var.databricks_etl_cluster_name
#  node_type_id            = data.databricks_node_type.smallest.id
#  spark_version           = "13.1.x-scala2.12"
#  autotermination_minutes = 10
#  num_workers             = 1
#  spark_conf = {
#    format("fs.azure.account.auth.type.%s.dfs.core.windows.net", var.storage_account_name)              = "OAuth"
#    format("fs.azure.account.oauth.provider.type.%s.dfs.core.windows.net", var.storage_account_name)    = "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider"
#    format("fs.azure.account.oauth2.client.id.%s.dfs.core.windows.net", var.storage_account_name)       = format("{{secrets/%s/sp-databricks-poc-app-id}}", databricks_secret_scope.akv_secret_scope.name)
#    format("fs.azure.account.oauth2.client.secret.%s.dfs.core.windows.net", var.storage_account_name)   = format("{{secrets/%s/sp-databricks-poc-app-secret}}", databricks_secret_scope.akv_secret_scope.name)
#    format("fs.azure.account.oauth2.client.endpoint.%s.dfs.core.windows.net", var.storage_account_name) = format("https://login.microsoftonline.com/%s/oauth2/token", var.tenant_id)
#  }
#  dynamic "library" {
#    for_each = ["langchain==0.0.239", "openai==0.27.8", "matplotlib==3.7.2"]
#    content {
#      pypi {
#        package = library.value
#      }
#    }
#  }
#
#  depends_on = [
#    databricks_secret_scope.akv_secret_scope
#  ]
#}
#
## Starter point for workflow creation using notebooks for tasks with a Sequential/Fan-Out pattern.
#resource "databricks_job" "etl_job" {
#  name = "Databricks PoC Workflow"
#
#  git_source {
#    url      = var.databricks_repo_url
#    provider = var.git_provider
#    branch   = "main"
#  }
#
#  task {
#    task_key = "bronze"
#
#    new_cluster {
#      num_workers   = 1
#      spark_version = "13.1.x-scala2.12"
#      node_type_id  = data.databricks_node_type.smallest.id
#      spark_conf = {
#        format("fs.azure.account.auth.type.%s.dfs.core.windows.net", var.storage_account_name)              = "OAuth"
#        format("fs.azure.account.oauth.provider.type.%s.dfs.core.windows.net", var.storage_account_name)    = "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider"
#        format("fs.azure.account.oauth2.client.id.%s.dfs.core.windows.net", var.storage_account_name)       = format("{{secrets/%s/sp-databricks-poc-app-id}}", databricks_secret_scope.akv_secret_scope.name)
#        format("fs.azure.account.oauth2.client.secret.%s.dfs.core.windows.net", var.storage_account_name)   = format("{{secrets/%s/sp-databricks-poc-app-secret}}", databricks_secret_scope.akv_secret_scope.name)
#        format("fs.azure.account.oauth2.client.endpoint.%s.dfs.core.windows.net", var.storage_account_name) = format("https://login.microsoftonline.com/%s/oauth2/token", var.tenant_id)
#      }
#    }
#
#    notebook_task {
#      notebook_path = "notebooks/bronze/ingest"
#      source        = "Git Provider"
#      base_parameters = {
#        storage_account_name = var.storage_account_name
#        container_name       = var.storage_account_container_name
#      }
#    }
#  }
#
#  dynamic "task" {
#    for_each = ["PIT", "NE", "GB"]
#    content {
#      task_key = format("silver-%s", task.value)
#
#      depends_on {
#        task_key = "bronze"
#      }
#
#      new_cluster {
#        num_workers   = 1
#        spark_version = "13.1.x-scala2.12"
#        node_type_id  = data.databricks_node_type.smallest.id
#        spark_conf = {
#          format("fs.azure.account.auth.type.%s.dfs.core.windows.net", var.storage_account_name)              = "OAuth"
#          format("fs.azure.account.oauth.provider.type.%s.dfs.core.windows.net", var.storage_account_name)    = "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider"
#          format("fs.azure.account.oauth2.client.id.%s.dfs.core.windows.net", var.storage_account_name)       = format("{{secrets/%s/sp-databricks-poc-app-id}}", databricks_secret_scope.akv_secret_scope.name)
#          format("fs.azure.account.oauth2.client.secret.%s.dfs.core.windows.net", var.storage_account_name)   = format("{{secrets/%s/sp-databricks-poc-app-secret}}", databricks_secret_scope.akv_secret_scope.name)
#          format("fs.azure.account.oauth2.client.endpoint.%s.dfs.core.windows.net", var.storage_account_name) = format("https://login.microsoftonline.com/%s/oauth2/token", var.tenant_id)
#        }
#      }
#
#      notebook_task {
#        notebook_path = "notebooks/silver/curate"
#        source        = "Git Provider"
#        base_parameters = {
#          target_team          = task.value
#          storage_account_name = var.storage_account_name
#          container_name       = var.storage_account_container_name
#        }
#      }
#    }
#  }
#
#  depends_on = [
#    databricks_cluster.etl_cluster
#  ]
#}
