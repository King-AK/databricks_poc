variable "poc_storage_account" {
  description = "The storage account name for the POC"
  type        = string
  default     = "dbxpocsac"
}

variable "poc_resource_group" {
  description = "The resource group for the POC"
  type        = string
}

variable "poc_location" {
  description = "The location for the POC"
  type        = string
}

variable "poc_projects" {
  description = "The projects for the POC"
  type = list(object({
    name     = string
    metadata = map(string)
  }))
}

