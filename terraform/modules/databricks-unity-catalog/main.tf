resource "databricks_sql_endpoint" "general_small_endpoint" {
  name                      = "dbx-poc-sql-endpoint"
  cluster_size              = "2X-Small"
  max_num_clusters          = 1
  auto_stop_mins            = 10
  enable_serverless_compute = true

  tags {
    custom_tags {
      key   = "project"
      value = "dbxpoc"
    }
  }
}


// TODO set up unity catalog + dataase for projects
