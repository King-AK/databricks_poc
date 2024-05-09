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

variable "projects" {
  description = "A list of projects to create"
  type        = list(object({
    name         = string
    storage_root = string
  }))
}
