variable "databricks_workspace_resource_id" {
  description = "The resource ID of the Databricks workspace"
  type        = string
}

variable "databricks_workspace_id" {
  description = "The ID of the Databricks workspace"
  type        = number
}

variable "databricks_location" {
  description = "The location for the Databricks workspace"
  type        = string
}

variable "databricks_storage_root" {
  description = "The root path for the Databricks workspace storage account"
  type        = string
}

variable "databricks_external_access_connector_id" {
  description = "The ID of the Databricks external access connector"
  type        = string
}
