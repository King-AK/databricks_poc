variable "databricks_workspace_name" {
  description = "Name for the Databricks workspace"
  type        = string
  default     = "poc-ws"
}

variable "databricks_resource_group" {
  description = "Name of the resource group for the Databricks workspace"
  type        = string
}

variable "databricks_location" {
  description = "The location for the Databricks workspace"
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "databricks_sku" {
  description = "The SKU of the Databricks workspace"
  type        = string
  default     = "premium"
}

variable "lake_storage_account_resource_id" {
  description = "The resource ID of the storage account to use for the Databricks workspace"
  type        = string
}
