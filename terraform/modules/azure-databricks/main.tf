resource "azurerm_databricks_workspace" "databricks_workspace" {
  name                = var.databricks_workspace_name
  resource_group_name = var.databricks_resource_group
  location            = var.databricks_location
  sku                 = var.databricks_sku
  tags = var.tags
}