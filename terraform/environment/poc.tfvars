poc_storage_account = "dbxpocsac"
poc_resource_group  = "dbxpoc-rg"
poc_location        = "eastus"
poc_projects        = [
  {
    name : "dummy-project"
    metadata : {
      "description" : "dummy project for the lake"
    }
  },
  {
    name : "dummy-project-2"
    metadata : {
      "description" : "dummy project for the lake"
    }
  },
  {
    name : "dummy-project-3"
    metadata : {
      "description" : "dummy project for the lake"
    }
  },
  {
    name : "spotify-chart-project"
    metadata : {
      "description" : "spotify chart project built with kaggle dataset"
    }
  }
]