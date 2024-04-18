variable "poc_storage_account" {
  description = "The storage account name for the POC"
  type        = string
  default     = "dbxpocsac"
}

variable "poc_resource_group" {
  description = "The resource group for the POC"
  type        = string
}

variable "poc_location" {
  description = "The location for the POC"
  type        = string
}

variable "poc_projects" {
  description = "The projects for the POC"
  type        = list(object({
    name     = string
    metadata = map(string)
  }))
}

resource "azurerm_resource_group" "poc_resource_group" {
  name     = var.poc_resource_group
  location = var.poc_location
}

module "azure-lake" {
  source                    = "./modules/azure-lake"
  lake_storage_account_name = var.poc_storage_account
  lake_resource_group_name  = var.poc_resource_group
  lake_location             = var.poc_location
  tags                      = {
    project = "dbxpoc"
  }
  projects   = var.poc_projects
  depends_on = [azurerm_resource_group.poc_resource_group]
}

module "azure-databricks-workspace" {
  source                    = "./modules/azure-databricks"
  databricks_resource_group = var.poc_resource_group
  databricks_location       = var.poc_location
  tags                      = {
    project = "dbxpoc"
  }
  depends_on                       = [azurerm_resource_group.poc_resource_group]
  lake_storage_account_resource_id = module.azure-lake.storage_account_id
}

module "azure-databricks-unity-catalog" {
  source                  = "./modules/databricks-unity-catalog"
  depends_on              = [module.azure-databricks-workspace]
  databricks_location     = var.poc_location
  databricks_storage_root = format("abfss://%s@%s.dfs.core.windows.net",
    module.azure-lake.databricks_root_container_name,
    module.azure-lake.storage_account_name)
  databricks_workspace_id                 = module.azure-databricks-workspace.databricks_workspace_id
  databricks_external_access_connector_id = module.azure-databricks-workspace.databricks_external_access_connector_id
}

