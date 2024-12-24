variable "location" {

}
 variable "resource_group_name" {}
 variable "name" {}

variable "client_secret" {
  type = string
  sensitive = true
}
variable "client_id" {}