variable "resource_group_name" {
  type        = string
  description = "lihi-resource-group"
}
variable "location" {
  type        = string
  default     = "West Europe"
  description = "West Europe"
}
variable "azurerm_subscription" {
  type        = string
  description = "/subscriptions/d94fe338-52d8-4a44-acd4-4f8301adf2cf/resourceGroups/lihi-resource-group"

}