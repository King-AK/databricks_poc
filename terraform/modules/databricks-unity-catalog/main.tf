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
  region        = var.databricks_location
  storage_root  = var.databricks_storage_root
  delta_sharing_scope = "INTERNAL"
  delta_sharing_recipient_token_lifetime_in_seconds = 3600
}

resource "databricks_metastore_assignment" "this" {
  workspace_id         = var.databricks_workspace_id
  metastore_id         = databricks_metastore.this.id
  depends_on = [databricks_metastore.this]
}

resource "databricks_storage_credential" "external" {
  name = "external-storage-credential"
  azure_managed_identity {
    access_connector_id = var.databricks_external_access_connector_id
  }
  comment = "Managed by Terraform"
  depends_on = [databricks_metastore_assignment.this]
}