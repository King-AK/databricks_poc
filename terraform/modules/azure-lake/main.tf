resource "azurerm_storage_account" "lake" {
  name                     = var.lake_storage_account_name
  resource_group_name      = var.lake_resource_group_name
  location                 = var.lake_location
  is_hns_enabled           = true
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags                     = var.tags
}

resource "azurerm_storage_container" "databricks_root_container" {
  name                  = "databricks-unity-catalog-root"
  storage_account_name  = azurerm_storage_account.lake.name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.lake]
}

resource "azurerm_storage_container" "project_container" {
  for_each = {for project in var.projects : project.name => project}

  name                  = each.key
  storage_account_name  = azurerm_storage_account.lake.name
  container_access_type = "private"
  metadata              = each.value.metadata

  depends_on = [azurerm_storage_account.lake]
}

resource "azurerm_storage_blob" "layer_readme" {
  for_each = {
    for val in setproduct(var.projects, fileset("./${path.module}/data/layer-readmes", "*")) :"${val[0].name}-${val[1]}"
    => { project = val[0], file = val[1] }
  }

  name                   = replace(each.value.file, "-", "/")
  storage_account_name   = azurerm_storage_account.lake.name
  storage_container_name = each.value.project.name
  type                   = "Block"
  source                 = abspath("./${path.module}/data/layer-readmes/${each.value.file}")

  depends_on = [azurerm_storage_container.project_container]
}

