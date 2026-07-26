# resource "databricks_sql_endpoint" "general_small_endpoint" {
#   name                      = "general-small-sql-endpoint"
#   cluster_size              = "2X-Small"
#   max_num_clusters          = 1
#   auto_stop_mins            = 10
#   enable_serverless_compute = true

#   tags {
#     custom_tags {
#       key   = "project"
#       value = "general"
#     }
#   }
# }

resource "databricks_storage_credential" "external" {
  name = "external-storage-credential"
  azure_managed_identity {
    access_connector_id = var.databricks_external_access_connector_id
  }
  comment = "Managed by Terraform"
}

resource "databricks_external_location" "some" {
  name = "external"
  url  = var.databricks_storage_root

  credential_name = databricks_storage_credential.external.id
  comment         = "Managed by Terraform"
  depends_on      = [databricks_storage_credential.external]
}

resource "databricks_external_location" "project_external_locations" {
  for_each = { for project in var.projects : project.name => project }

  name = each.key
  url  = each.value.storage_root

  credential_name = databricks_storage_credential.external.id
  comment         = "Managed by Terraform"
  depends_on      = [databricks_storage_credential.external]
}

// Create a catalog per project with gold/silver/bronze databases
resource "databricks_catalog" "project_catalog" {
  for_each = { for project in var.projects : project.name => project }

  name         = each.key
  storage_root = each.value.storage_root
  comment      = "Managed by Terraform"
  properties = {
    purpose = "For ${each.key} project"
  }
  depends_on = [databricks_external_location.project_external_locations]
}

// Create bronze, silver, and gold databases in each project catalog
resource "databricks_schema" "bronze_schema" {
  for_each = databricks_catalog.project_catalog

  catalog_name = each.value.name
  name         = "bronze"
  comment      = "this database is managed by terraform"
  storage_root = "${each.value.storage_root}bronze"
}

resource "databricks_schema" "silver_schema" {
  for_each = databricks_catalog.project_catalog

  catalog_name = each.value.name
  name         = "silver"
  comment      = "this database is managed by terraform"
  storage_root = "${each.value.storage_root}silver"
}

resource "databricks_schema" "gold_schema" {
  for_each = databricks_catalog.project_catalog

  catalog_name = each.value.name
  name         = "gold"
  comment      = "this database is managed by terraform"
  storage_root = "${each.value.storage_root}gold"
}