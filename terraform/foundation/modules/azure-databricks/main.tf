resource "azurerm_databricks_workspace" "databricks_workspace" {
  name                = var.databricks_workspace_name
  resource_group_name = var.databricks_resource_group
  location            = var.databricks_location
  sku                 = var.databricks_sku
  tags = var.tags
}

resource "azurerm_databricks_access_connector" "ext_access_connector" {
  name                = "ext-databricks-mi"
  resource_group_name = var.databricks_resource_group
  location            = var.databricks_location
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "ext_storage" {
  scope                = var.lake_storage_account_resource_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.ext_access_connector.identity[0].principal_id
}