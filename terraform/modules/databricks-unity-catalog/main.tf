resource "databricks_sql_endpoint" "general_small_endpoint" {
  name                      = "general-small-sql-endpoint"
  cluster_size              = "2X-Small"
  max_num_clusters          = 1
  auto_stop_mins            = 10
  enable_serverless_compute = true

  tags {
    custom_tags {
      key   = "project"
      value = "general"
    }
  }
}

resource "databricks_metastore" "this" {
  name          = "dbxpocms"
  force_destroy = true
  region        = var.databricks_location
  storage_root  = var.databricks_storage_root
}

resource "databricks_metastore_assignment" "this" {
  workspace_id         = var.databricks_workspace_id
  metastore_id         = databricks_metastore.this.id
  default_catalog_name = "hive_metastore"
}

resource "databricks_storage_credential" "external" {
  name = "external-storage-credential"
  azure_managed_identity {
    access_connector_id = var.databricks_external_access_connector_id
  }
  comment = "Managed by Terraform"
}