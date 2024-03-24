variable "lake_storage_account_name" {
  description = "Name for the data lake storage account"
  type        = string
  default     = "lake"
}

variable "lake_resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "lake_location" {
  description = "The location for the resources"
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "projects" {
  description = "A list of projects to create"
  type        = list(object({
    name = string
    metadata = map(string)
  }))
  default = []
}
