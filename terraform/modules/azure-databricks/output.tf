output "databricks_workspace_url" {
  value = "https://${azurerm_databricks_workspace.databricks_workspace.workspace_url}"
}

output "databricks_workspace_id" {
  value = azurerm_databricks_workspace.databricks_workspace.id
}

output "databricks_workspace_name" {
  value = azurerm_databricks_workspace.databricks_workspace.name
}