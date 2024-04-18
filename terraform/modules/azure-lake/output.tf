output "databricks_root_container_name" {
  value = azurerm_storage_container.databricks_root_container.name
}

output "storage_account_name" {
  value = azurerm_storage_account.lake.name
}

output "storage_account_id" {
  value = azurerm_storage_account.lake.id
}