output "databricks_root_container_name" {
  value = azurerm_storage_container.databricks_root_container.name
}

output "storage_account_name" {
  value = azurerm_storage_account.lake.name
}

output "storage_account_id" {
  value = azurerm_storage_account.lake.id
}

output "project_outputs" {
  value = [
    for container in azurerm_storage_container.project_container : {
      name = container.name
      storage_root = format("abfss://%s@%s.dfs.core.windows.net",
        container.name,
        azurerm_storage_account.lake.name)
    }

  ]

}