output "databricks_workspace_url" {
  value = "https://${azurerm_databricks_workspace.databricks_workspace.workspace_url}"
}

output "databricks_workspace_id" {
  value = azurerm_databricks_workspace.databricks_workspace.workspace_id
}

output "databricks_workspace_resource_id" {
  value = azurerm_databricks_workspace.databricks_workspace.id
}

output "databricks_workspace_name" {
  value = azurerm_databricks_workspace.databricks_workspace.name
}

output "databricks_external_access_connector_id" {
  value = azurerm_databricks_access_connector.ext_access_connector.id
}

